# Conecta Nexus - Microservicio Piloto `auth-service` (UFPS)

[![Universidad](https://img.shields.io/badge/UFPS-C%C3%BAcuta-aa1916.svg)](https://ww2.ufps.edu.co/)
[![Backend](https://img.shields.io/badge/Backend-Django%205%20%7C%20DRF%20%7C%20SimpleJWT-092E20.svg)](https://www.djangoproject.com/)
[![Frontend](https://img.shields.io/badge/Frontend-Nuxt%204%20%7C%20Vue%203%20%7C%20Tailwind-00DC82.svg)](https://nuxt.com/)
[![Package Manager](https://img.shields.io/badge/pnpm-11.x-f69220.svg)](https://pnpm.io/)
[![Cloud](https://img.shields.io/badge/Infra-GCP%20Compute%20Engine%20%7C%20Terraform-4285F4.svg)](https://cloud.google.com/)
[![Legal Compliance](https://img.shields.io/badge/Compliance-Ley%201581%20de%202012%20(Habeas%20Data)-darkred.svg)](https://www.funcionpublica.gov.co/eva/gestornormativo/norma.php?i=49981)

---

## 1. Contexto del Proyecto y Objetivo del Piloto

**Conecta Nexus** es una plataforma digital de vinculación académico-empresarial desarrollada en el Programa de Ingeniería de Sistemas de la **Universidad Francisco de Paula Santander (UFPS, Sede Cúcuta)**. Su objetivo es intermediar entre empresas con necesidades operativas reales y estudiantes de semestres avanzados (6.° a 10.° semestre) mediante soluciones validadas por docentes.

La arquitectura global del sistema sigue **Domain-Driven Design (DDD)** y el principio de **Database-per-Service**. Este repositorio contiene el corte vertical funcional e independiente del microservicio fundacional:

> **`auth-service` (Identidad, Seguridad y Cumplimiento Normativo)**
> - Backend RESTful con Django 5, DRF y SimpleJWT.
> - Frontend reactivo con Nuxt 4 + Vue 3 + Tailwind CSS gestionado con `pnpm`.
> - Persistencia relacional aislada (*Database-per-Service*).
> - Infraestructura cloud en Google Cloud Platform (GCP) automatizada con Terraform.

---

## 2. Requerimientos Funcionales y Marco Legal

| Requerimiento | Descripción Técnica |
| :--- | :--- |
| **RF01 (Autorregistro por Rol)** | Registro de usuarios asignando rol de `ESTUDIANTE` o `EMPRESA`. |
| **RF02 (Autenticación JWT)** | Emisión de pares de tokens criptográficos `access` (60 min) y `refresh` (24 h). |
| **RF03 (Control RBAC)** | Claims enriquecidos en el JWT (`user_id`, `email`, `role`, `habeas_data_consent`). |
| **RF05 (Cierre de Sesión)** | Destrucción de tokens en el cliente y expulsión de rutas protegidas. |
| **RF09 (Ley 1581 de 2012)** | **Consentimiento explícito y obligatorio de Habeas Data**. El registro es bloqueado (HTTP `400`) si el usuario no otorga el consentimiento previo e informado. Registro de auditoría temporal (`consent_date`). |

---

## 3. Estructura del Repositorio

```text
conecta-nexus-pilot/
├── backend/                       # Microservicio REST Django 5 + DRF + SimpleJWT
│   ├── auth_service/              # Configuración del proyecto (settings, urls, wsgi)
│   ├── authentication/            # App de dominio (models, serializers, views, urls, tests)
│   ├── manage.py                  # CLI de gestión Django
│   └── requirements.txt           # Dependencias Python
├── frontend/                      # Aplicación Web Nuxt 4 + Vue 3 + Tailwind CSS
│   ├── composables/               # useAuth.ts (gestión de estado reactivo y JWT)
│   ├── middleware/                # auth.ts (protección de rutas del lado cliente/SSR)
│   ├── pages/                     # login.vue, register.vue, dashboard.vue, index.vue
│   ├── assets/css/main.css        # Estilos base con paleta institucional UFPS
│   ├── nuxt.config.ts             # Configuración de Nuxt 4 y runtimeConfig
│   └── package.json               # Dependencias de frontend gestionadas con pnpm
├── infra/                         # Aprovisionamiento en Google Cloud con Terraform
│   ├── main.tf                    # Recursos: GCE VM, static IP, reglas de firewall
│   ├── variables.tf               # Variables parametrizables (project_id, región, zona)
│   ├── outputs.tf                 # Salidas: URLs, IP pública, comandos de SSH y diagnóstico
│   └── startup.sh                 # Script bash de aprovisionamiento desatendido (systemd)
└── README.md                      # Documentación completa y guía de evaluación
```

---

## 4. Guía de Ejecución Local

### Prerrequisitos
- Python 3.10+ (probado en Python 3.14)
- Node.js 20+ y `pnpm` (`pnpm --version >= 9.x`)

### 4.1 Puesta en Marcha del Backend (`backend/`)

1. Crear el entorno virtual e instalar dependencias:
   ```bash
   cd backend
   python3 -m venv .venv
   source .venv/bin/activate
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

2. Aplicar migraciones del modelo de usuario personalizado:
   ```bash
   python manage.py migrate
   ```

3. Ejecutar suite de pruebas unitarias automatizadas:
   ```bash
   python manage.py test authentication
   ```
   *(Valida el rechazo de registros sin Ley 1581, login JWT y protección de `/me/`)*.

4. (Opcional) Crear superusuario administrativo:
   ```bash
   python manage.py createsuperuser
   ```

5. Iniciar el servidor backend en el puerto `8000`:
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

El backend quedará escuchando en `http://localhost:8000/api/v1/auth/`.

---

### 4.2 Puesta en Marcha del Frontend (`frontend/`)

1. Abrir otra terminal y navegar al directorio `frontend/`:
   ```bash
   cd frontend
   ```

2. Instalar dependencias con `pnpm`:
   ```bash
   pnpm install
   ```

3. Iniciar el servidor de desarrollo:
   ```bash
   pnpm run dev
   ```

4. Abrir en el navegador:
   👉 **`http://localhost:3000/`** (Redirige automáticamente a `/login`).

---

## 5. Endpoints de la API REST (`backend/`)

| Método | Endpoint | Acceso | Descripción |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/v1/auth/register/` | Público | Registro de usuario (valida `habeas_data_consent=true`). |
| `POST` | `/api/v1/auth/login/` | Público | Inicio de sesión. Retorna `{ access, refresh, role, email, user_id }`. |
| `POST` | `/api/v1/auth/refresh/` | Público | Refresco de token de acceso JWT. |
| `GET` | `/api/v1/auth/me/` | **Protegido** (`Bearer <token>`) | Perfil del usuario activo y trazabilidad legal. |
| `GET` | `/api/v1/auth/health/` | Público | Healthcheck del microservicio para evaluadores y GCP. |

---

## 6. Despliegue en Google Cloud Platform (GCP) con Terraform

La infraestructura despliega una instancia **Google Compute Engine (`e2-small`)** en la región `us-central1`, asigna una **IP pública estática**, configura el **Firewall** para permitir puertos `22`, `8000` y `3000`, y ejecuta el script `startup.sh` mediante `systemd`.

### Pasos de Despliegue:

1. Autenticar credenciales de GCP en la terminal:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```

2. Navegar al directorio de infraestructura:
   ```bash
   cd infra
   ```

3. Inicializar y aplicar la configuración de Terraform:
   ```bash
   terraform init
   terraform apply -var="project_id=TU_PROJECT_ID_GCP"
   ```

4. Terraform mostrará al finalizar los outputs:
   - `public_ip`: Dirección IP estática de la VM.
   - `frontend_url`: `http://<IP_PUBLICA>:3000`
   - `backend_api_url`: `http://<IP_PUBLICA>:8000/api/v1/auth/`
   - `ssh_command`: Conexión directa por consola GCP.

5. Monitorear los logs del aprovisionamiento en la VM:
   ```bash
   # Conectarse vía SSH:
   gcloud compute ssh conecta-nexus-auth-pilot --zone=us-central1-a

   # Ver logs del script de inicio:
   sudo journalctl -u google-startup-scripts.service -f

   # Ver logs de backend y frontend:
   sudo journalctl -u conecta-backend -f
   sudo journalctl -u conecta-frontend -f
   ```

---

## 7. Matriz de Verificación y Criterios de Aceptación (DoD)

Para la sustentación ante el evaluador, se pueden comprobar los 5 criterios de aceptación mediante la interfaz gráfica o vía `curl`:

### Criterio 1: Prueba de Registro Legal (Rechazo sin Habeas Data)
```bash
curl -i -X POST http://localhost:8000/api/v1/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "estudiante.prueba@ufps.edu.co",
    "password": "Password123*",
    "role": "ESTUDIANTE",
    "habeas_data_consent": false
  }'
```
> **Resultado Esperado:** Código HTTP `400 Bad Request` con mensaje: *"Debe autorizar de manera previa y explícita el tratamiento de sus datos personales conforme a la Ley 1581 de 2012 (Habeas Data) para continuar."*

---

### Criterio 2: Prueba de Creación de Cuenta (Registro Exitoso)
```bash
curl -i -X POST http://localhost:8000/api/v1/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "estudiante.prueba@ufps.edu.co",
    "password": "Password123*",
    "role": "ESTUDIANTE",
    "habeas_data_consent": true
  }'
```
> **Resultado Esperado:** Código HTTP `201 Created` con payload de confirmación, `consent_date` con timestamp de auditoría y contraseña cifrada con PBKDF2 en la base de datos.

---

### Criterio 3: Prueba de Login JWT
```bash
curl -i -X POST http://localhost:8000/api/v1/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{
    "email": "estudiante.prueba@ufps.edu.co",
    "password": "Password123*"
  }'
```
> **Resultado Esperado:** Código HTTP `200 OK` retornando los tokens criptográficos `access`, `refresh`, y los metadatos `role`, `email`, `user_id`.

---

### Criterio 4: Prueba de Vista Protegida (`GET /me/` y Dashboard)
```bash
# Sin token:
curl -i http://localhost:8000/api/v1/auth/me/
# -> HTTP 401 Unauthorized

# Con token Bearer:
curl -i http://localhost:8000/api/v1/auth/me/ \
  -H "Authorization: Bearer <TOKEN_ACCESS_AQUI>"
# -> HTTP 200 OK con id, email, rol, habeas_data_consent y consent_date
```
> **Resultado en Front-End:** En `/dashboard`, el usuario ve su tarjeta de identidad académica/empresarial, su badge de rol, su confirmación de Habeas Data con fecha y hora, y el botón para Cerrar Sesión. Si el token no existe, Nuxt expulsa al usuario hacia `/login`.

---

### Criterio 5: Prueba de Infraestructura Terraform
- `terraform validate` arroja `Success! The configuration is valid.`
- `terraform apply` genera la instancia con IP estática y reglas de firewall abiertas para los puertos 22, 8000 y 3000.
