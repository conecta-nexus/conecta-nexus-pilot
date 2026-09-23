#!/usr/bin/env bash
set -eo pipefail

# ==============================================================================
# Conecta Nexus (UFPS) - Destruir Infraestructura Cloud (GCP)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INFRA_DIR="${REPO_ROOT}/infra"

echo -e "\033[1;31m========================================================\033[0m"
echo -e "\033[1;31m   Conecta Nexus (UFPS) - Destruir Recursos en GCP      \033[0m"
echo -e "\033[1;31m========================================================\033[0m"

# 1. Determinar el Project ID de GCP
PROJECT_ID="${1:-}"

if [ -z "${PROJECT_ID}" ]; then
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
  echo "Uso: ./scripts/stop_cloud.sh [GCP_PROJECT_ID] [-y|--auto-approve]"
  exit 1
fi

# 2. Confirmación de seguridad
AUTO_APPROVE=""
if [[ "${2:-}" == "-y" ]] || [[ "${2:-}" == "--auto-approve" ]] || [[ "${1:-}" == "-y" ]]; then
  AUTO_APPROVE="-auto-approve"
else
  echo -e "\n\033[1;31m[ADVERTENCIA] Esta acción destruirá por completo los siguientes recursos en GCP:\033[0m"
  echo " - Instancia Compute Engine (conecta-nexus-auth-pilot)"
  echo " - Dirección IP pública estática"
  echo " - Reglas de Firewall asociadas"
  echo ""
  read -r -p "¿Está seguro de que desea proceder con la destrucción? (escriba 'si' para confirmar): " CONFIRMATION
  if [ "${CONFIRMATION}" != "si" ] && [ "${CONFIRMATION}" != "sí" ] && [ "${CONFIRMATION}" != "yes" ]; then
    echo -e "\n\033[1;33m[CANCELADO] Operación de destrucción cancelada por el usuario.\033[0m\n"
    exit 0
  fi
  AUTO_APPROVE="-auto-approve"
fi

echo -e "\n\033[1;34m[-] Ejecutando terraform destroy en infra/...\033[0m"
cd "${INFRA_DIR}"

terraform destroy ${AUTO_APPROVE} -var="project_id=${PROJECT_ID}"

echo -e "\n\033[1;32m========================================================\033[0m"
echo -e "\033[1;32m   [OK] Todos los recursos en GCP han sido eliminados.  \033[0m"
echo -e "\033[1;32m   No se generarán costos adicionales en su cuenta GCP. \033[0m"
echo -e "\033[1;32m========================================================\033[0m\n"
