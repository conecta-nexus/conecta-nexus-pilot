#!/usr/bin/env bash
set -eo pipefail

# ==============================================================================
# Conecta Nexus (UFPS) - Iniciar Servicios Locales (Backend + Frontend)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${REPO_ROOT}/.local_services.pid"
LOG_DIR="${REPO_ROOT}/logs"

mkdir -p "${LOG_DIR}"

echo -e "\033[1;36m========================================================\033[0m"
echo -e "\033[1;36m   Conecta Nexus (UFPS) - Inicio de Servicios Locales   \033[0m"
echo -e "\033[1;36m========================================================\033[0m"

# Detener instancias previas si existen
"${SCRIPT_DIR}/stop_local.sh" >/dev/null 2>&1 || true

# 1. Preparar y arrancar Backend Django (Puerto 8000)
echo -e "\n\033[1;34m[1/2] Iniciando Backend Django (Puerto 8000)...\033[0m"
cd "${REPO_ROOT}/backend"

if [ ! -d ".venv" ]; then
  echo "[-] Creando entorno virtual Python en backend/.venv..."
  python3 -m venv .venv
  .venv/bin/pip install --upgrade pip
  .venv/bin/pip install -r requirements.txt
fi

echo "[-] Aplicando migraciones de base de datos..."
.venv/bin/python manage.py migrate --noinput > "${LOG_DIR}/django_migrate.log" 2>&1

echo "[-] Levantando servidor Django en segundo plano..."
nohup .venv/bin/python manage.py runserver 0.0.0.0:8000 </dev/null > "${LOG_DIR}/backend.log" 2>&1 &
BACKEND_PID=$!
disown ${BACKEND_PID} 2>/dev/null || true
echo "    -> Backend iniciado con PID: ${BACKEND_PID}"

# 2. Preparar y arrancar Frontend Nuxt 4 con pnpm (Puerto 3000)
echo -e "\n\033[1;34m[2/2] Iniciando Frontend Nuxt 4 con pnpm (Puerto 3000)...\033[0m"
cd "${REPO_ROOT}/frontend"

if [ ! -d "node_modules" ]; then
  echo "[-] Instalando dependencias del frontend con pnpm..."
  pnpm install
fi

echo "[-] Levantando servidor de desarrollo Nuxt 4..."
export NUXT_PUBLIC_API_BASE="http://localhost:8000"
nohup pnpm run dev --host 0.0.0.0 --port 3000 </dev/null > "${LOG_DIR}/frontend.log" 2>&1 &
FRONTEND_PID=$!
disown ${FRONTEND_PID} 2>/dev/null || true
echo "    -> Frontend iniciado con PID: ${FRONTEND_PID}"

# Guardar PIDs
echo "${BACKEND_PID}" > "${PID_FILE}"
echo "${FRONTEND_PID}" >> "${PID_FILE}"

# Esperar para verificación de arranque
echo "[-] Verificando disponibilidad de los servicios..."
sleep 3

echo -e "\n\033[1;32m========================================================\033[0m"
echo -e "\033[1;32m   [OK] Servicios locales ejecutándose exitosamente!    \033[0m"
echo -e "\033[1;32m========================================================\033[0m"
echo -e " - \033[1mFrontend Web (Nuxt 4):\033[0m   \033[4;36mhttp://localhost:3000\033[0m"
echo -e " - \033[1mBackend REST API:\033[0m        \033[4;36mhttp://localhost:8000/api/v1/auth/\033[0m"
echo -e " - \033[1mHealthcheck:\033[0m             \033[4;36mhttp://localhost:8000/api/v1/auth/health/\033[0m"
echo -e " - \033[1mLogs en tiempo real:\033[0m"
echo -e "     tail -f ${LOG_DIR}/backend.log"
echo -e "     tail -f ${LOG_DIR}/frontend.log"
echo -e "\nPara detener los servicios en cualquier momento, ejecute:"
echo -e " \033[1;33m./scripts/stop_local.sh\033[0m"
echo -e "\033[1;32m========================================================\033[0m\n"
