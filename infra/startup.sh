#!/bin/bash
set -euo pipefail

# ==============================================================================
# Script de Aprovisionamiento Desatendido para VM de Conecta Nexus Piloto (UFPS)
# SO: Debian 12 (Bookworm) en Google Compute Engine
# Herramientas: Python 3, pnpm, Node.js 20+, systemd, Gunicorn
# ==============================================================================

LOG_FILE="/var/log/conecta-startup.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Iniciando aprovisionamiento del servidor Conecta Nexus..."

# 1. Actualización de paquetes del sistema
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
  python3 \
  python3-pip \
  python3-venv \
  git \
  curl \
  wget \
  build-essential \
  sqlite3 \
  jq

# 2. Instalación de Node.js 20.x LTS
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Instalando Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# 3. Instalación de pnpm (preferido sobre npm)
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Instalando pnpm globalmente..."
npm install -g pnpm
export PATH="/usr/local/bin:/usr/bin:$PATH"

echo "Node version: $(node -v)"
echo "pnpm version: $(pnpm -v)"
echo "Python version: $(python3 --version)"

# 4. Preparación del directorio de la aplicación
APP_DIR="/opt/conecta-nexus"
mkdir -p "${APP_DIR}"

# 5. Obtención de la IP pública de la máquina para configurar NUXT_PUBLIC_API_BASE
EXTERNAL_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip || echo "127.0.0.1")
echo "IP Publica detectada: ${EXTERNAL_IP}"

# 6. Clonar o sincronizar repositorio
REPO_URL=$(curl -s -f -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo_url || true)
if [ -z "${REPO_URL}" ] || [ "${REPO_URL}" = "null" ]; then
  REPO_URL="https://github.com/conecta-nexus/conecta-nexus-pilot.git"
fi

echo "Clonando/actualizando repositorio desde ${REPO_URL}..."
if [ -d "${APP_DIR}/.git" ]; then
  cd "${APP_DIR}"
  git fetch origin main
  git reset --hard origin/main
else
  rm -rf "${APP_DIR}"
  git clone "${REPO_URL}" "${APP_DIR}"
fi

# Si el código ya se encuentra en el directorio, configurar entornos
if [ -d "${APP_DIR}/backend" ]; then
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Configurando Backend Django..."
  cd "${APP_DIR}/backend"
  python3 -m venv .venv
  .venv/bin/pip install --upgrade pip
  .venv/bin/pip install -r requirements.txt
  .venv/bin/python manage.py migrate
fi

if [ -d "${APP_DIR}/frontend" ]; then
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] Configurando Frontend Nuxt 4 con pnpm..."
  cd "${APP_DIR}/frontend"
  export NUXT_PUBLIC_API_BASE="http://${EXTERNAL_IP}:8000"
  pnpm install
  pnpm build
fi

# 7. Configuración de unidades systemd para ejecución robusta en segundo plano
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Registrando servicios systemd..."

# Backend Django Gunicorn Service
cat <<EOF > /etc/systemd/system/conecta-backend.service
[Unit]
Description=Conecta Nexus Auth Service Backend (Django + Gunicorn)
After=network.target

[Service]
User=root
WorkingDirectory=${APP_DIR}/backend
Environment="PATH=${APP_DIR}/backend/.venv/bin:/usr/local/bin:/usr/bin"
Environment="ALLOWED_HOSTS=*"
ExecStart=${APP_DIR}/backend/.venv/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 auth_service.wsgi:application
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Frontend Nuxt Nitro Service
cat <<EOF > /etc/systemd/system/conecta-frontend.service
[Unit]
Description=Conecta Nexus Auth Frontend (Nuxt 4 Nitro Server)
After=network.target conecta-backend.service

[Service]
User=root
WorkingDirectory=${APP_DIR}/frontend
Environment="PATH=/usr/local/bin:/usr/bin"
Environment="NODE_ENV=production"
Environment="NITRO_HOST=0.0.0.0"
Environment="NITRO_PORT=3000"
Environment="NUXT_PUBLIC_API_BASE=http://${EXTERNAL_IP}:8000"
ExecStart=/usr/bin/node ${APP_DIR}/frontend/.output/server/index.mjs
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 8. Recargar y arrancar servicios si existen los artefactos construidos
systemctl daemon-reload

if [ -f "${APP_DIR}/backend/manage.py" ]; then
  systemctl enable conecta-backend.service
  systemctl restart conecta-backend.service || true
fi

if [ -f "${APP_DIR}/frontend/.output/server/index.mjs" ]; then
  systemctl enable conecta-frontend.service
  systemctl restart conecta-frontend.service || true
fi

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Aprovisionamiento finalizado con éxito."
