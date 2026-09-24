<script setup lang="ts">
import { Mail, Lock, Eye, EyeOff, AlertCircle } from 'lucide-vue-next'

const { login, isLoading, errorMessage, initAuth, isAuthenticated } = useAuth()
const router = useRouter()

const roleTab = ref<'student' | 'company'>('student')
const showPassword = ref(false)

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
    clientError.value = 'Por favor ingresa tu correo electrónico y contraseña.'
    return
  }

  const result = await login(form.value.email.trim(), form.value.password)
  if (!result.success) {
    // errorMessage is handled reactively by useAuth
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-4 py-12" style="background: #080F1E;">
    <div class="w-full max-w-md">
      <!-- Header -->
      <div class="text-center mb-8">
        <div class="flex justify-center mb-6">
          <NuxtLink to="/">
            <Logo size="lg" />
          </NuxtLink>
        </div>
        <h1 class="text-2xl font-bold text-white mb-1" style="font-family: 'Plus Jakarta Sans', sans-serif;">
          Iniciar sesión
        </h1>
        <p class="text-sm" style="color: #6B8CAE;">
          Accede a tu cuenta en Conecta Nexus
        </p>
      </div>

      <!-- Main Card -->
      <div
        class="rounded-2xl p-8 border shadow-glow-card"
        style="background: #0F1F36; border-color: #1E3355;"
      >
        <!-- Role Selector Tabs -->
        <div
          class="flex rounded-lg p-1 mb-6"
          style="background: #0D1B2E;"
        >
          <button
            type="button"
            @click="roleTab = 'student'"
            class="flex-1 py-2 rounded-md text-sm font-medium transition-all cursor-pointer"
            :style="roleTab === 'student' ? { background: '#1E3355', color: '#60A5FA' } : { color: '#6B8CAE' }"
          >
            Estudiante
          </button>
          <button
            type="button"
            @click="roleTab = 'company'"
            class="flex-1 py-2 rounded-md text-sm font-medium transition-all cursor-pointer"
            :style="roleTab === 'company' ? { background: '#1E3355', color: '#60A5FA' } : { color: '#6B8CAE' }"
          >
            Empresa
          </button>
        </div>

        <!-- Error Alert -->
        <div
          v-if="clientError || errorMessage"
          class="mb-5 p-3.5 rounded-xl border flex items-start gap-2.5 text-xs sm:text-sm animate-fade-in"
          style="background: rgba(220, 38, 38, 0.1); border-color: rgba(220, 38, 38, 0.3); color: #FCA5A5;"
        >
          <AlertCircle :size="18" class="text-red-400 shrink-0 mt-0.5" />
          <div class="flex-grow">
            {{ clientError || errorMessage }}
          </div>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <!-- Email Field -->
          <div>
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              Correo electrónico
            </label>
            <div class="relative">
              <Mail :size="16" class="absolute left-3.5 top-1/2 -translate-y-1/2" style="color: #4A6B8A;" />
              <input
                v-model="form.email"
                type="email"
                required
                autocomplete="email"
                :placeholder="roleTab === 'student' ? 'estudiante@ufps.edu.co' : 'contacto@empresa.com'"
                class="w-full pl-10 pr-4 py-2.5 rounded-lg text-sm outline-none transition-colors"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
            </div>
          </div>

          <!-- Password Field -->
          <div>
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              Contraseña
            </label>
            <div class="relative">
              <Lock :size="16" class="absolute left-3.5 top-1/2 -translate-y-1/2" style="color: #4A6B8A;" />
              <input
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                required
                autocomplete="current-password"
                placeholder="••••••••"
                class="w-full pl-10 pr-10 py-2.5 rounded-lg text-sm outline-none transition-colors"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3.5 top-1/2 -translate-y-1/2 transition-colors cursor-pointer"
                style="color: #4A6B8A;"
                tabindex="-1"
              >
                <EyeOff v-if="showPassword" :size="16" />
                <Eye v-else :size="16" />
              </button>
            </div>
          </div>

          <!-- Forgot Password Link -->
          <div class="flex items-center justify-end">
            <span class="text-xs transition-colors cursor-pointer hover:underline" style="color: #3B82F6;">
              ¿Olvidaste tu contraseña?
            </span>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="isLoading"
            class="w-full py-3 rounded-lg font-semibold text-white transition-all hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 mt-2 shadow-glow-blue cursor-pointer"
            style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
          >
            <svg v-if="isLoading" class="animate-spin h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span>{{ isLoading ? 'Ingresando...' : 'Ingresar' }}</span>
          </button>

          <!-- Divider -->
          <div class="relative flex items-center gap-3 my-4">
            <div class="flex-1 h-px" style="background: #1E3355;" />
            <span class="text-xs" style="color: #4A6B8A;">o continúa con</span>
            <div class="flex-1 h-px" style="background: #1E3355;" />
          </div>

          <!-- Google Button (Mocked aesthetic from prototype) -->
          <button
            type="button"
            class="w-full py-2.5 rounded-lg font-medium text-sm flex items-center justify-center gap-3 border transition-all hover:bg-white/5 cursor-pointer"
            style="border-color: #253D5F; color: #94A3B8;"
          >
            <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
              <path d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844c-.209 1.125-.843 2.078-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.615z" fill="#4285F4"/>
              <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 009 18z" fill="#34A853"/>
              <path d="M3.964 10.71A5.41 5.41 0 013.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 000 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
              <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 00.957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
            </svg>
            <span>Continuar con Google</span>
          </button>
        </form>

        <p class="text-center text-xs mt-6" style="color: #4A6B8A;">
          ¿No tienes cuenta?
          <NuxtLink to="/register" class="font-medium hover:underline ml-1" style="color: #3B82F6;">
            Regístrate aquí
          </NuxtLink>
        </p>
      </div>
    </div>
  </div>
</template>
