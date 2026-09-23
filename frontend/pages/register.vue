<script setup lang="ts">
const { register, isLoading, errorMessage, initAuth, isAuthenticated } = useAuth()
const router = useRouter()

const form = ref({
  email: '',
  password: '',
  confirmPassword: '',
  role: 'ESTUDIANTE' as 'ESTUDIANTE' | 'EMPRESA',
  habeas_data_consent: false,
})

const clientError = ref<string | null>(null)
const successMessage = ref<string | null>(null)
const showLegalModal = ref(false)

onMounted(async () => {
  await initAuth()
  if (isAuthenticated.value) {
    router.push('/dashboard')
  }
})

const handleSubmit = async () => {
  clientError.value = null
  successMessage.value = null

  // Client validations
  if (!form.value.email.trim()) {
    clientError.value = 'Por favor ingrese su correo electrónico institucional o corporativo.'
    return
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(form.value.email.trim())) {
    clientError.value = 'El formato del correo electrónico no es válido.'
    return
  }

  if (form.value.password.length < 6) {
    clientError.value = 'La contraseña debe contener al menos 6 caracteres.'
    return
  }

  if (form.value.password !== form.value.confirmPassword) {
    clientError.value = 'Las contraseñas no coinciden. Por favor verifíquelas.'
    return
  }

  // Habeas Data validation - Acceptance Criterion 1
  if (!form.value.habeas_data_consent) {
    clientError.value =
      'Debe autorizar de manera explícita el tratamiento de sus datos personales conforme a la Ley 1581 de 2012 (Habeas Data) para poder registrarse en Conecta Nexus.'
    return
  }

  const result = await register({
    email: form.value.email.trim(),
    password: form.value.password,
    role: form.value.role,
    habeas_data_consent: form.value.habeas_data_consent,
  })

  if (result.success) {
    successMessage.value = '¡Registro exitoso! Redirigiendo a la pantalla de inicio de sesión...'
    setTimeout(() => {
      router.push('/login')
    }, 1800)
  }
}
</script>

<template>
  <div class="flex-grow flex items-center justify-center p-4 sm:p-6 lg:p-8">
    <div class="w-full max-w-lg space-y-6">
      <!-- Header -->
      <div class="text-center space-y-2">
        <div class="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-gradient-to-br from-ufps-600 to-ufps-800 text-white font-black text-2xl shadow-glow-red ring-1 ring-white/20">
          CN
        </div>
        <h1 class="text-2xl sm:text-3xl font-bold tracking-tight text-white">
          Crear Cuenta en <span class="text-ufps-500">Conecta Nexus</span>
        </h1>
        <p class="text-xs sm:text-sm text-slate-400">
          Plataforma Institucional de Vinculación Universidad - Empresa &bull; UFPS
        </p>
      </div>

      <!-- Card container -->
      <div class="glass-panel p-6 sm:p-8 rounded-2xl shadow-2xl space-y-6">
        <div class="border-b border-slate-800 pb-3">
          <h2 class="text-lg font-semibold text-slate-200">Autorregistro por Rol</h2>
          <p class="text-xs text-slate-400">Seleccione su tipo de vinculación y complete los datos requeridos.</p>
        </div>

        <!-- Success Alert -->
        <div v-if="successMessage" class="p-3.5 rounded-xl bg-emerald-950/70 border border-emerald-700 text-emerald-200 text-xs sm:text-sm flex items-center gap-2.5">
          <svg class="w-5 h-5 text-emerald-400 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <div class="font-medium">{{ successMessage }}</div>
        </div>

        <!-- Error Alert -->
        <div v-if="clientError || errorMessage" class="p-3.5 rounded-xl bg-red-950/70 border border-red-800 text-red-200 text-xs sm:text-sm flex items-start gap-2.5">
          <svg class="w-5 h-5 text-red-400 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <div class="flex-grow">
            {{ clientError || errorMessage }}
          </div>
        </div>

        <!-- Registration Form -->
        <form @submit.prevent="handleSubmit" class="space-y-4" novalidate>
          <!-- Role selector cards -->
          <div>
            <label class="block text-xs font-medium text-slate-300 mb-2">
              Tipo de Actor en el Ecosistema
            </label>
            <div class="grid grid-cols-2 gap-3">
              <button
                type="button"
                @click="form.role = 'ESTUDIANTE'"
                :class="[
                  'p-3.5 rounded-xl border text-left transition-all duration-200 flex flex-col gap-1',
                  form.role === 'ESTUDIANTE'
                    ? 'border-ufps-600 bg-ufps-950/40 ring-1 ring-ufps-600/50 shadow-glow-red'
                    : 'border-slate-800 bg-slate-900/60 hover:border-slate-700'
                ]"
              >
                <div class="flex items-center justify-between">
                  <span class="text-sm font-semibold text-white">Estudiante</span>
                  <span v-if="form.role === 'ESTUDIANTE'" class="w-2 h-2 rounded-full bg-ufps-500"></span>
                </div>
                <span class="text-[11px] text-slate-400">Semestres 6.° a 10.° UFPS</span>
              </button>

              <button
                type="button"
                @click="form.role = 'EMPRESA'"
                :class="[
                  'p-3.5 rounded-xl border text-left transition-all duration-200 flex flex-col gap-1',
                  form.role === 'EMPRESA'
                    ? 'border-emerald-600 bg-emerald-950/40 ring-1 ring-emerald-600/50 shadow-glow-blue'
                    : 'border-slate-800 bg-slate-900/60 hover:border-slate-700'
                ]"
              >
                <div class="flex items-center justify-between">
                  <span class="text-sm font-semibold text-white">Empresa</span>
                  <span v-if="form.role === 'EMPRESA'" class="w-2 h-2 rounded-full bg-emerald-500"></span>
                </div>
                <span class="text-[11px] text-slate-400">Entidad o aliado productivo</span>
              </button>
            </div>
          </div>

          <!-- Email -->
          <div>
            <label for="reg-email" class="block text-xs font-medium text-slate-300 mb-1.5">
              Correo Electrónico
            </label>
            <input
              id="reg-email"
              v-model="form.email"
              type="email"
              autocomplete="email"
              required
              :placeholder="form.role === 'ESTUDIANTE' ? 'nombre.codigo@ufps.edu.co' : 'contacto@empresa.com'"
              class="glass-input w-full px-4 py-2.5 rounded-xl text-sm text-white placeholder-slate-500"
            />
          </div>

          <!-- Passwords -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label for="reg-password" class="block text-xs font-medium text-slate-300 mb-1.5">
                Contraseña
              </label>
              <input
                id="reg-password"
                v-model="form.password"
                type="password"
                autocomplete="new-password"
                required
                placeholder="Mínimo 6 carácteres"
                class="glass-input w-full px-4 py-2.5 rounded-xl text-sm text-white placeholder-slate-500"
              />
            </div>
            <div>
              <label for="reg-confirm-password" class="block text-xs font-medium text-slate-300 mb-1.5">
                Confirmar Contraseña
              </label>
              <input
                id="reg-confirm-password"
                v-model="form.confirmPassword"
                type="password"
                autocomplete="new-password"
                required
                placeholder="Repetir contraseña"
                class="glass-input w-full px-4 py-2.5 rounded-xl text-sm text-white placeholder-slate-500"
              />
            </div>
          </div>

          <!-- Habeas Data / Legal Consent Checkbox (Ley 1581 de 2012) -->
          <div class="p-4 rounded-xl bg-slate-900/80 border border-slate-800 space-y-2 mt-4">
            <div class="flex items-start gap-3">
              <input
                id="habeas-data-checkbox"
                v-model="form.habeas_data_consent"
                type="checkbox"
                class="mt-1 h-4 w-4 rounded border-slate-700 bg-slate-950 text-ufps-600 focus:ring-ufps-500 focus:ring-offset-slate-900 cursor-pointer"
              />
              <label for="habeas-data-checkbox" class="text-xs text-slate-300 leading-relaxed cursor-pointer select-none">
                <strong class="text-white font-semibold">Consentimiento Obligatorio:</strong>
                Autorizo de manera previa, expresa e informada a la Universidad Francisco de Paula Santander (UFPS) para el tratamiento de mis datos personales según la
                <span class="text-ufps-400 font-semibold underline underline-offset-2">Ley 1581 de 2012 (Habeas Data)</span>
                y la política de privacidad institucional para fines académicos y de vinculación laboral.
              </label>
            </div>
          </div>

          <!-- Submit button -->
          <button
            type="submit"
            :disabled="isLoading || !!successMessage"
            class="w-full py-3 px-4 rounded-xl bg-ufps-600 hover:bg-ufps-700 active:bg-ufps-800 text-white font-medium text-sm transition-all duration-200 shadow-glow-red hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 mt-3"
          >
            <svg v-if="isLoading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span>{{ isLoading ? 'Procesando registro...' : 'Crear Cuenta en Conecta Nexus' }}</span>
          </button>
        </form>

        <div class="pt-4 border-t border-slate-800 text-center text-xs text-slate-400">
          ¿Ya tienes una cuenta creada?
          <NuxtLink to="/login" class="text-ufps-400 hover:text-ufps-300 font-semibold underline underline-offset-4 ml-1">
            Inicia sesión
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>
