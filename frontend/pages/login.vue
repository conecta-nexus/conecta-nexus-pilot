<script setup lang="ts">
const { login, isLoading, errorMessage, initAuth, isAuthenticated } = useAuth()
const router = useRouter()

const form = ref({
  email: '',
  password: '',
})

const clientError = ref<string | null>(null)

onMounted(async () => {
  await initAuth()
  if (isAuthenticated.value) {
    router.push('/dashboard')
  }
})

const handleSubmit = async () => {
  clientError.value = null
  if (!form.value.email || !form.value.password) {
    clientError.value = 'Por favor ingrese su correo electrónico y contraseña.'
    return
  }

  const result = await login(form.value.email.trim(), form.value.password)
  if (!result.success) {
    // errorMessage is already populated in useAuth
  }
}
</script>

<template>
  <div class="flex-grow flex items-center justify-center p-4 sm:p-6 lg:p-8">
    <div class="w-full max-w-md space-y-8">
      <!-- Header / Logo -->
      <div class="text-center space-y-2">
        <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-gradient-to-br from-ufps-600 to-ufps-800 text-white font-black text-2xl shadow-glow-red ring-1 ring-white/20">
          CN
        </div>
        <h1 class="text-2xl sm:text-3xl font-bold tracking-tight text-white">
          Conecta <span class="text-ufps-500">Nexus</span>
        </h1>
        <p class="text-xs sm:text-sm text-slate-400">
          Universidad Francisco de Paula Santander &bull; Iniciar Sesión
        </p>
      </div>

      <!-- Card container -->
      <div class="glass-panel p-6 sm:p-8 rounded-2xl shadow-2xl space-y-6">
        <div class="border-b border-slate-800 pb-4">
          <h2 class="text-lg font-semibold text-slate-200">Acceso a la Plataforma</h2>
          <p class="text-xs text-slate-400">Ingrese sus credenciales registradas como Estudiante o Empresa.</p>
        </div>

        <!-- Alert messages -->
        <div v-if="clientError || errorMessage" class="p-3.5 rounded-xl bg-red-950/60 border border-red-800/80 text-red-200 text-xs sm:text-sm flex items-start gap-2.5">
          <svg class="w-5 h-5 text-red-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <div class="flex-grow">
            {{ clientError || errorMessage }}
          </div>
        </div>

        <!-- Login Form -->
        <form @submit.prevent="handleSubmit" class="space-y-4" novalidate>
          <div>
            <label for="login-email" class="block text-xs font-medium text-slate-300 mb-1.5">
              Correo Electrónico
            </label>
            <input
              id="login-email"
              v-model="form.email"
              type="email"
              autocomplete="username"
              required
              placeholder="ejemplo@ufps.edu.co"
              class="glass-input w-full px-4 py-2.5 rounded-xl text-sm text-white placeholder-slate-500"
            />
          </div>

          <div>
            <div class="flex items-center justify-between mb-1.5">
              <label for="login-password" class="block text-xs font-medium text-slate-300">
                Contraseña
              </label>
            </div>
            <input
              id="login-password"
              v-model="form.password"
              type="password"
              autocomplete="current-password"
              required
              placeholder="••••••••"
              class="glass-input w-full px-4 py-2.5 rounded-xl text-sm text-white placeholder-slate-500"
            />
          </div>

          <button
            type="submit"
            :disabled="isLoading"
            class="w-full py-3 px-4 rounded-xl bg-ufps-600 hover:bg-ufps-700 active:bg-ufps-800 text-white font-medium text-sm transition-all duration-200 shadow-glow-red hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 mt-2"
          >
            <svg v-if="isLoading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span>{{ isLoading ? 'Validando credenciales...' : 'Ingresar a Conecta Nexus' }}</span>
          </button>
        </form>

        <div class="pt-4 border-t border-slate-800 text-center text-xs text-slate-400">
          ¿No tienes una cuenta aún?
          <NuxtLink to="/register" class="text-ufps-400 hover:text-ufps-300 font-semibold underline underline-offset-4 ml-1">
            Regístrate aquí
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>
