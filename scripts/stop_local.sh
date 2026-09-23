#!/usr/bin/env bash
set -eo pipefail

# ==============================================================================
# Conecta Nexus (UFPS) - Detener Servicios Locales (Backend + Frontend)
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PID_FILE="${REPO_ROOT}/.local_services.pid"

echo -e "\033[1;33m========================================================\033[0m"
echo -e "\033[1;33m   Conecta Nexus (UFPS) - Deteniendo Servicios Locales  \033[0m"
echo -e "\033[1;33m========================================================\033[0m"

STOPPED=0

# 1. Terminar procesos registrados en el archivo de PIDs
if [ -f "${PID_FILE}" ]; then
  echo "[-] Leyendo PIDs registrados en ${PID_FILE}..."
  while read -r PID; do
    if [ -n "${PID}" ] && kill -0 "${PID}" 2>/dev/null; then
      echo "    -> Deteniendo proceso PID: ${PID}..."
      kill "${PID}" 2>/dev/null || true
      sleep 0.5
      if kill -0 "${PID}" 2>/dev/null; then
        kill -9 "${PID}" 2>/dev/null || true
      fi
      STOPPED=1
    fi
  done < "${PID_FILE}"
  rm -f "${PID_FILE}"
fi

# 2. Búsqueda y detención preventiva por puertos (8000 y 3000)
# Port 8000 (Django runserver)
PIDS_8000=$(lsof -ti :8000 2>/dev/null || true)
if [ -n "${PIDS_8000}" ]; then
  echo "[-] Liberando puerto 8000 (PID: ${PIDS_8000})..."
  kill ${PIDS_8000} 2>/dev/null || true
  sleep 0.5
  kill -9 ${PIDS_8000} 2>/dev/null || true
  STOPPED=1
fi

# Port 3000 (Nuxt 4 / Vite dev server)
PIDS_3000=$(lsof -ti :3000 2>/dev/null || true)
if [ -n "${PIDS_3000}" ]; then
  echo "[-] Liberando puerto 3000 (PID: ${PIDS_3000})..."
  kill ${PIDS_3000} 2>/dev/null || true
  sleep 0.5
  kill -9 ${PIDS_3000} 2>/dev/null || true
  STOPPED=1
fi

if [ "${STOPPED}" -eq 1 ]; then
  echo -e "\n\033[1;32m[OK] Todos los servicios locales (puertos 8000 y 3000) han sido detenidos correctamente.\033[0m\n"
else
  echo -e "\n\033[1;34m[INFO] No se encontraron servicios locales en ejecución.\033[0m\n"
fi
