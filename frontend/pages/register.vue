<script setup lang="ts">
import { 
  GraduationCap, 
  Building2, 
  ArrowRight, 
  ArrowLeft, 
  Check, 
  AlertCircle, 
  CheckCircle2,
  FileText,
  X
} from 'lucide-vue-next'

const { register, isLoading, errorMessage, initAuth, isAuthenticated } = useAuth()
const router = useRouter()

type RoleType = 'student' | 'company'

const role = ref<RoleType | null>('student')
const step = ref<1 | 2>(1)

const form = ref({
  firstName: '',
  lastName: '',
  companyName: '',
  city: 'Cúcuta',
  email: '',
  career: 'Ingeniería de Sistemas',
  semester: '8',
  sector: 'Tecnología de Software',
  password: '',
  habeas_data_consent: false,
})

const careers = [
  'Ingeniería de Sistemas',
  'Ingeniería Industrial',
  'Ingeniería Electrónica',
  'Ingeniería Civil',
  'Administración de Empresas',
  'Contaduría Pública',
  'Otra',
]

const sectors = [
  'Tecnología de Software',
  'Manufactura Industrial',
  'Ciencia de Datos',
  'Logística y Distribución',
  'Salud',
  'Educación',
  'Finanzas',
  'Retail',
  'Otro',
]

const clientError = ref<string | null>(null)
const successMessage = ref<string | null>(null)
const showLegalModal = ref(false)

onMounted(async () => {
  await initAuth()
  if (isAuthenticated.value) {
    router.push('/dashboard')
  }
})

const handleSelectRole = (r: RoleType) => {
  role.value = r
}

const handleContinueToStep2 = () => {
  if (role.value) {
    step.value = 2
  }
}

const handleSubmit = async () => {
  clientError.value = null
  successMessage.value = null

  if (!form.value.email.trim()) {
    clientError.value = 'Por favor ingresa tu correo electrónico.'
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

  // Legal requirement Ley 1581 de 2012
  if (!form.value.habeas_data_consent) {
    clientError.value =
      'Debes autorizar el tratamiento de datos personales conforme a la Ley 1581 de 2012 (Habeas Data) para continuar.'
    return
  }

  const roleValue = role.value === 'company' ? 'EMPRESA' : 'ESTUDIANTE'

  const result = await register({
    email: form.value.email.trim(),
    password: form.value.password,
    role: roleValue,
    habeas_data_consent: form.value.habeas_data_consent,
  })

  if (result.success) {
    successMessage.value = '¡Cuenta creada exitosamente! Redirigiendo al inicio de sesión...'
    setTimeout(() => {
      router.push('/login')
    }, 1500)
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-4 py-12" style="background: #080F1E;">
    <div class="w-full max-w-lg">
      <!-- Header -->
      <div class="text-center mb-8">
        <div class="flex justify-center mb-5">
          <NuxtLink to="/">
            <Logo size="lg" />
          </NuxtLink>
        </div>
        <h1 class="text-2xl font-bold text-white mb-1" style="font-family: 'Plus Jakarta Sans', sans-serif;">
          Crear cuenta
        </h1>
        <p class="text-sm" style="color: #6B8CAE;">
          Únete a la plataforma de vinculación académica
        </p>
      </div>

      <!-- Progress Indicator -->
      <div class="flex items-center gap-2 mb-8 justify-center">
        <div class="flex items-center gap-2">
          <div
            class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold transition-all"
            :style="step >= 1 ? { background: '#3B82F6', color: '#fff' } : { background: '#1A2E4A', color: '#4A6B8A' }"
          >
            <Check v-if="step > 1" :size="13" />
            <span v-else>1</span>
          </div>
          <div
            class="w-20 h-px transition-all"
            :style="{ background: step > 1 ? '#3B82F6' : '#1E3355' }"
          />
        </div>
        <div class="flex items-center gap-2">
          <div
            class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold transition-all"
            :style="step >= 2 ? { background: '#3B82F6', color: '#fff' } : { background: '#1A2E4A', color: '#4A6B8A' }"
          >
            <span>2</span>
          </div>
        </div>
      </div>

      <!-- Main Card -->
      <div
        class="rounded-2xl p-8 border shadow-glow-card"
        style="background: #0F1F36; border-color: #1E3355;"
      >
        <!-- Alerts -->
        <div
          v-if="successMessage"
          class="mb-6 p-4 rounded-xl border flex items-center gap-3 text-xs sm:text-sm animate-fade-in"
          style="background: rgba(16, 185, 129, 0.1); border-color: rgba(16, 185, 129, 0.3); color: #6EE7B7;"
        >
          <CheckCircle2 :size="18" class="text-emerald-400 shrink-0" />
          <span>{{ successMessage }}</span>
        </div>

        <div
          v-if="clientError || errorMessage"
          class="mb-6 p-3.5 rounded-xl border flex items-start gap-2.5 text-xs sm:text-sm animate-fade-in"
          style="background: rgba(220, 38, 38, 0.1); border-color: rgba(220, 38, 38, 0.3); color: #FCA5A5;"
        >
          <AlertCircle :size="18" class="text-red-400 shrink-0 mt-0.5" />
          <div class="flex-grow">
            {{ clientError || errorMessage }}
          </div>
        </div>

        <!-- Step 1: Role Selection -->
        <div v-if="step === 1">
          <h2 class="text-lg font-semibold text-white mb-1">¿Cuál es tu rol?</h2>
          <p class="text-sm mb-6" style="color: #6B8CAE;">
            Selecciona el tipo de cuenta que deseas crear.
          </p>

          <div class="grid grid-cols-2 gap-4 mb-6">
            <!-- Student Option -->
            <button
              type="button"
              @click="handleSelectRole('student')"
              class="relative p-6 rounded-xl text-left transition-all border cursor-pointer group"
              :style="role === 'student' ? { background: '#1A2E4A', borderColor: '#3B82F6' } : { background: '#0D1B2E', borderColor: '#1E3355' }"
            >
              <div
                v-if="role === 'student'"
                class="absolute top-3 right-3 w-5 h-5 rounded-full flex items-center justify-center"
                style="background: #3B82F6;"
              >
                <Check :size="12" class="text-white" />
              </div>
              <div
                class="w-10 h-10 rounded-xl flex items-center justify-center mb-3"
                style="background: #1A2E4A;"
              >
                <GraduationCap :size="20" style="color: #3B82F6;" />
              </div>
              <p class="font-semibold text-white text-sm">Estudiante</p>
              <p class="text-xs mt-1" style="color: #6B8CAE;">
                Busco problemáticas empresariales
              </p>
            </button>

            <!-- Company Option -->
            <button
              type="button"
              @click="handleSelectRole('company')"
              class="relative p-6 rounded-xl text-left transition-all border cursor-pointer group"
              :style="role === 'company' ? { background: '#1A2E4A', borderColor: '#8B5CF6' } : { background: '#0D1B2E', borderColor: '#1E3355' }"
            >
              <div
                v-if="role === 'company'"
                class="absolute top-3 right-3 w-5 h-5 rounded-full flex items-center justify-center"
                style="background: #8B5CF6;"
              >
                <Check :size="12" class="text-white" />
              </div>
              <div
                class="w-10 h-10 rounded-xl flex items-center justify-center mb-3"
                style="background: #1A2E4A;"
              >
                <Building2 :size="20" style="color: #8B5CF6;" />
              </div>
              <p class="font-semibold text-white text-sm">Empresa</p>
              <p class="text-xs mt-1" style="color: #6B8CAE;">
                Publico problemáticas y busco talento
              </p>
            </button>
          </div>

          <button
            type="button"
            @click="handleContinueToStep2"
            :disabled="!role"
            class="w-full flex items-center justify-center gap-2 py-3 rounded-lg font-semibold text-white transition-all disabled:opacity-40 cursor-pointer shadow-glow-blue"
            style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
          >
            <span>Continuar</span>
            <ArrowRight :size="16" />
          </button>
        </div>

        <!-- Step 2: Information Form -->
        <form v-else @submit.prevent="handleSubmit" class="space-y-4">
          <div class="flex items-center gap-2 mb-4">
            <button
              type="button"
              @click="step = 1"
              class="p-1 rounded hover:bg-white/5 transition-colors cursor-pointer"
              style="color: #6B8CAE;"
            >
              <ArrowLeft :size="16" />
            </button>
            <h2 class="text-lg font-semibold text-white">
              {{ role === 'student' ? 'Perfil académico' : 'Información empresarial' }}
            </h2>
          </div>

          <!-- Name fields -->
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
                {{ role === 'student' ? 'Nombre' : 'Razón social' }}
              </label>
              <input
                v-if="role === 'student'"
                v-model="form.firstName"
                type="text"
                placeholder="Andrés"
                class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
              <input
                v-else
                v-model="form.companyName"
                type="text"
                placeholder="Industrias S.A.S."
                class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
            </div>
            <div>
              <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
                {{ role === 'student' ? 'Apellido' : 'Ciudad' }}
              </label>
              <input
                v-if="role === 'student'"
                v-model="form.lastName"
                type="text"
                placeholder="Quintero"
                class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
              <input
                v-else
                v-model="form.city"
                type="text"
                placeholder="Cúcuta"
                class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
                style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
              />
            </div>
          </div>

          <!-- Email -->
          <div>
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              Correo electrónico
            </label>
            <input
              v-model="form.email"
              type="email"
              required
              autocomplete="email"
              :placeholder="role === 'student' ? 'nombre@ufps.edu.co' : 'contacto@empresa.com'"
              class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
              style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
            />
          </div>

          <!-- Career / Sector -->
          <div>
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              {{ role === 'student' ? 'Carrera' : 'Sector empresarial' }}
            </label>
            <select
              v-if="role === 'student'"
              v-model="form.career"
              class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
              style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
            >
              <option v-for="c in careers" :key="c" :value="c">{{ c }}</option>
            </select>
            <select
              v-else
              v-model="form.sector"
              class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
              style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
            >
              <option v-for="s in sectors" :key="s" :value="s">{{ s }}</option>
            </select>
          </div>

          <!-- Semester (only student) -->
          <div v-if="role === 'student'">
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              Semestre actual
            </label>
            <select
              v-model="form.semester"
              class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
              style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
            >
              <option v-for="s in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]" :key="s" :value="s.toString()">
                {{ s }}° semestre
              </option>
            </select>
          </div>

          <!-- Password -->
          <div>
            <label class="block text-xs font-medium mb-1.5" style="color: #7B9CBF;">
              Contraseña
            </label>
            <input
              v-model="form.password"
              type="password"
              required
              autocomplete="new-password"
              placeholder="Mínimo 6 caracteres"
              class="w-full px-3 py-2.5 rounded-lg text-sm outline-none"
              style="background: #0D1B2E; border: 1px solid #253D5F; color: #EEF2FF;"
            />
          </div>

          <!-- Mandatory Habeas Data (Ley 1581 de 2012) -->
          <div class="p-3.5 rounded-xl border space-y-2 mt-4" style="background: #0D1B2E; border-color: #1E3355;">
            <div class="flex items-start gap-3">
              <input
                id="habeas-consent"
                v-model="form.habeas_data_consent"
                type="checkbox"
                required
                class="mt-1 h-4 w-4 rounded border-slate-700 text-blue-600 focus:ring-blue-500 bg-slate-900 cursor-pointer"
              />
              <label for="habeas-consent" class="text-xs leading-relaxed cursor-pointer select-none" style="color: #94A3B8;">
                Autorizo de manera previa, expresa e informada el tratamiento de mis datos personales de acuerdo con la 
                <span class="font-semibold text-white">Ley 1581 de 2012 (Habeas Data)</span> y las políticas de la plataforma.
              </label>
            </div>
            <div class="pl-7">
              <button
                type="button"
                @click="showLegalModal = true"
                class="text-[11px] underline flex items-center gap-1 cursor-pointer transition-colors"
                style="color: #60A5FA;"
              >
                <FileText :size="12" />
                <span>Ver Política y Términos Legales</span>
              </button>
            </div>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            :disabled="isLoading"
            class="w-full py-3 rounded-lg font-semibold text-white transition-all hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 mt-4 shadow-glow-blue cursor-pointer"
            style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
          >
            <svg v-if="isLoading" class="animate-spin h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z"></path>
            </svg>
            <span>{{ isLoading ? 'Creando cuenta...' : 'Crear cuenta' }}</span>
          </button>

          <p class="text-center text-xs mt-4" style="color: #4A6B8A;">
            ¿Ya tienes cuenta?
            <NuxtLink to="/login" class="font-medium hover:underline ml-1" style="color: #3B82F6;">
              Inicia sesión
            </NuxtLink>
          </p>
        </form>
      </div>
    </div>

    <!-- Modal Habeas Data -->
    <div
      v-if="showLegalModal"
      class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm"
      @click.self="showLegalModal = false"
    >
      <div
        class="w-full max-w-lg rounded-2xl border p-6 shadow-2xl relative max-h-[85vh] flex flex-col"
        style="background: #0F1F36; border-color: #253D5F;"
      >
        <div class="flex items-center justify-between pb-3 border-b" style="border-color: #1E3355;">
          <h3 class="text-base font-bold text-white flex items-center gap-2">
            <FileText :size="18" class="text-blue-400" />
            Consentimiento Habeas Data (Ley 1581 de 2012)
          </h3>
          <button
            @click="showLegalModal = false"
            class="p-1 rounded-lg hover:bg-white/10 text-slate-400 hover:text-white transition-colors cursor-pointer"
          >
            <X :size="18" />
          </button>
        </div>

        <div class="overflow-y-auto py-4 space-y-3 text-xs leading-relaxed" style="color: #94A3B8;">
          <p>
            En cumplimiento de la <strong class="text-white">Ley Estatutaria 1581 de 2012</strong> y el Decreto Reglamentario 1377 de 2013 de la República de Colombia, la plataforma <strong class="text-white">Conecta Nexus</strong> informa al titular de la información que los datos recolectados serán tratados con estricta confidencialidad.
          </p>
          <p class="font-semibold text-slate-200">1. Finalidades del Tratamiento:</p>
          <ul class="list-disc list-inside space-y-1 pl-2 text-slate-400">
            <li>Autenticación y control de acceso seguro basado en roles (RBAC).</li>
            <li>Vinculación y contacto entre la academia universitaria y el sector productivo.</li>
            <li>Auditoría de consentimiento y trazabilidad de solicitudes de vinculación.</li>
          </ul>
          <p class="font-semibold text-slate-200">2. Derechos del Titular:</p>
          <p>
            Usted tiene derecho a conocer, actualizar, rectificar y solicitar la supresión de sus datos personales, así como revocar la autorización otorgada mediante los canales habilitados.
          </p>
        </div>

        <div class="pt-3 border-t flex justify-end" style="border-color: #1E3355;">
          <button
            @click="showLegalModal = false; form.habeas_data_consent = true"
            class="px-5 py-2 rounded-lg text-xs font-semibold text-white transition-colors"
            style="background: #3B82F6;"
          >
            Entendido y Aceptar
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
