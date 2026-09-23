<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

const { user, logout, fetchMe, isLoading } = useAuth()
const isRefreshing = ref(false)

onMounted(async () => {
  isRefreshing.value = true
  await fetchMe()
  isRefreshing.value = false
})

const formatDate = (isoString?: string | null) => {
  if (!isoString) return 'No registrado'
  try {
    const date = new Date(isoString)
    return new Intl.DateTimeFormat('es-CO', {
      dateStyle: 'medium',
      timeStyle: 'short',
    }).format(date)
  } catch {
    return isoString
  }
}

const handleLogout = async () => {
  await logout()
}
</script>

<template>
  <div class="flex-grow max-w-7xl w-full mx-auto p-4 sm:p-6 lg:p-8 space-y-8">
    <!-- Top Navigation Bar -->
    <header class="glass-panel p-4 sm:p-5 rounded-2xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border border-slate-800 shadow-xl">
      <div class="flex items-center gap-3">
        <div class="w-11 h-11 rounded-xl bg-gradient-to-br from-ufps-600 to-ufps-800 text-white font-black text-xl flex items-center justify-center shadow-glow-red ring-1 ring-white/20">
          CN
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h1 class="text-lg font-bold text-white tracking-tight">Conecta Nexus</h1>
            <span class="text-[10px] uppercase font-bold tracking-widest px-2 py-0.5 rounded-full bg-ufps-600/20 text-ufps-400 border border-ufps-600/40">
              Piloto UFPS
            </span>
          </div>
          <p class="text-xs text-slate-400">Microservicio de Identidad, Seguridad y Cumplimiento (`auth-service`)</p>
        </div>
      </div>

      <div class="flex items-center gap-3 w-full sm:w-auto justify-between sm:justify-end">
        <div class="text-right hidden sm:block">
          <div class="text-xs font-semibold text-slate-200">{{ user?.email }}</div>
          <div class="text-[10px] text-slate-400">Sesión JWT Activa</div>
        </div>

        <button
          @click="handleLogout"
          class="px-4 py-2 rounded-xl bg-slate-900 hover:bg-red-950/40 border border-slate-800 hover:border-red-800/80 text-slate-300 hover:text-red-400 text-xs font-medium transition-all duration-200 flex items-center gap-2"
          title="Cerrar sesión y destruir tokens locales"
        >
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
          </svg>
          <span>Cerrar Sesión</span>
        </button>
      </div>
    </header>

    <!-- Main Content Area -->
    <div class="space-y-6">
      <!-- Welcome Hero Banner -->
      <div class="relative overflow-hidden rounded-3xl bg-gradient-to-r from-slate-900 via-slate-900/90 to-ufps-950/40 border border-slate-800 p-6 sm:p-8 shadow-2xl">
        <div class="relative z-10 max-w-2xl space-y-3">
          <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-950/60 border border-emerald-800/60 text-emerald-400 text-xs font-medium">
            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
            Autenticación Validada con SimpleJWT (RF02 / RF03)
          </div>
          <h2 class="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
            Bienvenido al Portal,
            <span class="text-ufps-400 block sm:inline mt-1 sm:mt-0 font-normal text-lg sm:text-2xl">{{ user?.email }}</span>
          </h2>
          <p class="text-xs sm:text-sm text-slate-400 leading-relaxed">
            Ha ingresado satisfactoriamente al corte vertical del microservicio <strong class="text-slate-200">auth-service</strong>. Este panel demuestra la resolución del perfil de usuario a través del endpoint protegido <code class="text-ufps-300 bg-slate-800/60 px-1.5 py-0.5 rounded text-xs">GET /api/v1/auth/me/</code>.
          </p>
        </div>
      </div>

      <!-- User Profile & Compliance Cards Grid -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Card 1: Identity & Role -->
        <div class="glass-panel p-6 rounded-2xl border border-slate-800 space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-xs font-medium uppercase tracking-wider text-slate-400">Identidad y Rol</span>
            <div class="w-8 h-8 rounded-lg bg-blue-500/10 text-blue-400 flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>
          </div>

          <div class="space-y-3">
            <div>
              <div class="text-[11px] text-slate-400">ID de Usuario (ORM):</div>
              <div class="text-lg font-mono font-bold text-white">#{{ user?.id ?? '...' }}</div>
            </div>

            <div>
              <div class="text-[11px] text-slate-400">Rol Institucional (RBAC):</div>
              <div class="mt-1">
                <span
                  v-if="user?.role === 'ESTUDIANTE'"
                  class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold bg-blue-950/80 text-blue-300 border border-blue-700/60 shadow-sm"
                >
                  <span class="w-2 h-2 rounded-full bg-blue-400"></span>
                  ESTUDIANTE (6.° - 10.° Semestre)
                </span>
                <span
                  v-else-if="user?.role === 'EMPRESA'"
                  class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold bg-emerald-950/80 text-emerald-300 border border-emerald-700/60 shadow-sm"
                >
                  <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
                  EMPRESA (Aliado Productivo)
                </span>
                <span
                  v-else
                  class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold bg-purple-950/80 text-purple-300 border border-purple-700/60 shadow-sm"
                >
                  <span class="w-2 h-2 rounded-full bg-purple-400"></span>
                  {{ user?.role ?? 'ADMIN' }}
                </span>
              </div>
            </div>

            <div>
              <div class="text-[11px] text-slate-400">Estado de Cuenta:</div>
              <div class="text-xs font-medium text-emerald-400 flex items-center gap-1.5 mt-0.5">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                Activo / Credenciales Válidas
              </div>
            </div>
          </div>
        </div>

        <!-- Card 2: Legal Compliance (Ley 1581 de 2012) -->
        <div class="glass-panel p-6 rounded-2xl border border-slate-800 space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-xs font-medium uppercase tracking-wider text-slate-400">Cumplimiento Normativo</span>
            <div class="w-8 h-8 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
            </div>
          </div>

          <div class="space-y-3">
            <div>
              <div class="text-[11px] text-slate-400">Habeas Data (Ley 1581 de 2012):</div>
              <div class="mt-1">
                <span
                  v-if="user?.habeas_data_consent"
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-semibold bg-emerald-950/80 text-emerald-300 border border-emerald-700/60"
                >
                  <svg class="w-3.5 h-3.5 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  Consentimiento Explícito Otorgado
                </span>
                <span
                  v-else
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-md text-xs font-semibold bg-red-950 text-red-300 border border-red-700"
                >
                  Sin Consentimiento
                </span>
              </div>
            </div>

            <div>
              <div class="text-[11px] text-slate-400">Registro Temporal de Auditoría:</div>
              <div class="text-xs font-mono text-slate-200 mt-0.5">
                {{ formatDate(user?.consent_date) }}
              </div>
            </div>

            <div class="pt-2 text-[11px] text-slate-400 border-t border-slate-800">
              Garantiza la trazabilidad exigida por la Superintendencia de Industria y Comercio (SIC) de Colombia.
            </div>
          </div>
        </div>

        <!-- Card 3: Microservice Context & Metadata -->
        <div class="glass-panel p-6 rounded-2xl border border-slate-800 space-y-4">
          <div class="flex items-center justify-between">
            <span class="text-xs font-medium uppercase tracking-wider text-slate-400">Arquitectura del Piloto</span>
            <div class="w-8 h-8 rounded-lg bg-ufps-500/10 text-ufps-400 flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
              </svg>
            </div>
          </div>

          <div class="space-y-2 text-xs">
            <div class="flex items-center justify-between py-1 border-b border-slate-800">
              <span class="text-slate-400">Patrón:</span>
              <span class="font-semibold text-slate-200">Database-per-Service (DDD)</span>
            </div>
            <div class="flex items-center justify-between py-1 border-b border-slate-800">
              <span class="text-slate-400">Backend:</span>
              <span class="font-mono text-slate-200">Django 5 + DRF SimpleJWT</span>
            </div>
            <div class="flex items-center justify-between py-1 border-b border-slate-800">
              <span class="text-slate-400">Frontend:</span>
              <span class="font-mono text-slate-200">Nuxt 4 + Vue 3 + pnpm</span>
            </div>
            <div class="flex items-center justify-between py-1">
              <span class="text-slate-400">Infraestructura:</span>
              <span class="font-semibold text-ufps-400">GCP Compute Engine (Terraform)</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Raw API Data Inspector for Evaluator Demonstration -->
      <div class="glass-panel p-6 rounded-2xl border border-slate-800 space-y-3">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-semibold text-slate-200 flex items-center gap-2">
            <svg class="w-4 h-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4" />
            </svg>
            Respuesta JSON en Vivo: <span class="text-xs font-mono text-slate-400">GET /api/v1/auth/me/</span>
          </h3>
          <button
            @click="fetchMe"
            :disabled="isRefreshing"
            class="text-xs px-3 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 flex items-center gap-1.5 transition-colors"
          >
            <svg :class="['w-3.5 h-3.5', isRefreshing ? 'animate-spin' : '']" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
            Refrescar /me/
          </button>
        </div>
        <pre class="bg-slate-950 p-4 rounded-xl text-xs font-mono text-emerald-400/90 overflow-x-auto border border-slate-800/80">{{ JSON.stringify(user, null, 2) }}</pre>
      </div>
    </div>
  </div>
</template>
