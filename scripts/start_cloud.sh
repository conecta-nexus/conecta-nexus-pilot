#!/usr/bin/env bash
set -eo pipefail

# ==============================================================================
# Conecta Nexus (UFPS) - Iniciar Infraestructura Cloud (GCP Cloud Shell / Local)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INFRA_DIR="${REPO_ROOT}/infra"

echo -e "\033[1;36m========================================================\033[0m"
echo -e "\033[1;36m  Conecta Nexus (UFPS) - Despliegue en Google Cloud GCP \033[0m"
echo -e "\033[1;36m========================================================\033[0m"

# 1. Determinar el Project ID de GCP
PROJECT_ID="${1:-}"

if [ -z "${PROJECT_ID}" ]; then
  # Intentar obtener el proyecto activo de gcloud
  if command -v gcloud &>/dev/null; then
    ACTIVE_PROJECT=$(gcloud config get-value project 2>/dev/null || true)
    if [ -n "${ACTIVE_PROJECT}" ] && [ "${ACTIVE_PROJECT}" != "(unset)" ]; then
      PROJECT_ID="${ACTIVE_PROJECT}"
      echo -e "[-] Proyecto GCP detectado desde gcloud: \033[1;32m${PROJECT_ID}\033[0m"
    fi
  fi
fi

if [ -z "${PROJECT_ID}" ]; then
  echo -e "\n\033[1;33m[?] Ingrese el ID de su proyecto en Google Cloud Platform:\033[0m"
  read -r -p "GCP Project ID: " INPUT_PROJECT
  PROJECT_ID="${INPUT_PROJECT}"
fi

if [ -z "${PROJECT_ID}" ]; then
  echo -e "\n\033[1;31m[ERROR] No se especificó un Project ID de GCP válido.\033[0m"
  echo "Uso: ./scripts/start_cloud.sh [GCP_PROJECT_ID]"
  echo "O configure su proyecto: gcloud config set project [GCP_PROJECT_ID]"
  exit 1
fi

echo -e "\n\033[1;34m[-] Inicializando Terraform en infra/...\033[0m"
cd "${INFRA_DIR}"

terraform init

echo -e "\n\033[1;34m[-] Aplicando aprovisionamiento en GCP (Instancia e2-small, IP estática, Firewall)...\033[0m"
# Si se pasa -y o --auto-approve como segundo argumento
AUTO_APPROVE=""
if [[ "${2:-}" == "-y" ]] || [[ "${2:-}" == "--auto-approve" ]] || [[ "${1:-}" == "-y" ]]; then
  AUTO_APPROVE="-auto-approve"
fi

terraform apply ${AUTO_APPROVE} -var="project_id=${PROJECT_ID}"

echo -e "\n\033[1;32m========================================================\033[0m"
echo -e "\033[1;32m   [OK] Despliegue en GCP completado exitosamente!     \033[0m"
echo -e "\033[1;32m========================================================\033[0m"

# Extraer y mostrar outputs útiles
PUBLIC_IP=$(terraform output -raw public_ip 2>/dev/null || echo "Desconocida")
FRONTEND_URL=$(terraform output -raw frontend_url 2>/dev/null || echo "http://${PUBLIC_IP}:3000")
BACKEND_URL=$(terraform output -raw backend_api_url 2>/dev/null || echo "http://${PUBLIC_IP}:8000/api/v1/auth/")

echo -e " - \033[1mIP Pública Estática:\033[0m     \033[1;37m${PUBLIC_IP}\033[0m"
echo -e " - \033[1mFrontend Web (Nuxt 4):\033[0m   \033[4;36m${FRONTEND_URL}\033[0m"
echo -e " - \033[1mBackend REST API:\033[0m        \033[4;36${BACKEND_URL}\033[0m"
echo -e " - \033[1mHealthcheck en Vivo:\033[0m     \033[4;36mhttp://${PUBLIC_IP}:8000/api/v1/auth/health/\033[0m"
echo -e "\nPara conectarse por SSH a la máquina virtual:"
echo -e " \033[1;33mgcloud compute ssh conecta-nexus-auth-pilot --zone=us-central1-a --project=${PROJECT_ID}\033[0m"
echo -e "\nPara destruir los recursos cuando finalice la evaluación:"
echo -e " \033[1;31m./scripts/stop_cloud.sh ${PROJECT_ID}\033[0m"
echo -e "\033[1;32m========================================================\033[0m\n"
