<script setup lang="ts">
import {
  LayoutDashboard,
  Search,
  FileText,
  Bell,
  User,
  LogOut,
  Briefcase,
  Users,
  CheckCircle2,
  Clock,
  TrendingUp,
  Sparkles,
  ChevronRight,
  Plus,
  ArrowRight,
  ShieldCheck,
  Building2,
  GraduationCap
} from 'lucide-vue-next'

definePageMeta({
  middleware: 'auth'
})

const { user, logout, fetchMe, accessToken, isLoading } = useAuth()
const isRefreshing = ref(false)

onMounted(async () => {
  isRefreshing.value = true
  await fetchMe()
  isRefreshing.value = false
})

const isStudent = computed(() => {
  return user.value?.role !== 'EMPRESA'
})

const userInitials = computed(() => {
  if (!user.value?.email) return 'CN'
  const namePart = user.value.email.split('@')[0]
  return namePart.slice(0, 2).toUpperCase()
})

const userDisplayName = computed(() => {
  if (!user.value?.email) return 'Usuario'
  const prefix = user.value.email.split('@')[0]
  return prefix.charAt(0).toUpperCase() + prefix.slice(1)
})

const formatDate = (isoString?: string | null) => {
  if (!isoString) return 'Registrado en sistema'
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

// Student mock data
const studentStats = [
  { label: 'Solicitudes enviadas', value: '3', Icon: FileText, color: '#3B82F6' },
  { label: 'Pendientes de respuesta', value: '1', Icon: Clock, color: '#F59E0B' },
  { label: 'Aceptadas', value: '1', Icon: CheckCircle2, color: '#10B981' },
  { label: 'Problemáticas disponibles', value: '18+', Icon: TrendingUp, color: '#8B5CF6' },
]

// Company mock data
const companyStats = [
  { label: 'Problemáticas activas', value: '4', Icon: Briefcase, color: '#3B82F6' },
  { label: 'Solicitudes recibidas', value: '5', Icon: Users, color: '#8B5CF6' },
  { label: 'Solicitudes pendientes', value: '2', Icon: Clock, color: '#F59E0B' },
  { label: 'Problemáticas en proceso', value: '2', Icon: TrendingUp, color: '#10B981' },
]

const studentFeaturedProblems = [
  {
    id: 1,
    title: 'Optimización de rutas de distribución urbana con IA',
    company: 'Logística Express S.A.S.',
    city: 'Cúcuta',
    status: 'Abierta',
    area: 'Ingeniería de Sistemas',
    tags: ['Python', 'Algoritmos Genéticos', 'GIS'],
  },
  {
    id: 2,
    title: 'Módulo de analítica predictiva de consumo energético',
    company: 'EnergiCo del Oriente',
    city: 'Cúcuta',
    status: 'Abierta',
    area: 'Ciencia de Datos',
    tags: ['Machine Learning', 'Vue.js', 'Django'],
  },
  {
    id: 3,
    title: 'Sistema IoT de monitoreo de temperatura en silos de almacenamiento',
    company: 'AgroNorte S.A.S.',
    city: 'Pamplona',
    status: 'En Proceso',
    area: 'Ingeniería Electrónica',
    tags: ['IoT', 'ESP32', 'MQTT'],
  },
]

const companyProblemsList = [
  {
    id: 1,
    title: 'Optimización de rutas de distribución urbana con IA',
    status: 'Abierta',
    desc: 'Buscamos rediseñar el cálculo de itinerarios en la zona metropolitana de Cúcuta reduciendo tiempos muertos y combustible.',
    requestsCount: 2,
  },
  {
    id: 2,
    title: 'Módulo de analítica predictiva de consumo energético',
    status: 'En Proceso',
    desc: 'Modelado estadístico y predictivo sobre lecturas históricas de telemetría eléctrica industrial.',
    requestsCount: 1,
  },
  {
    id: 3,
    title: 'Automatización de reportes de calidad industrial',
    status: 'Abierta',
    desc: 'Pipeline ETL para consolidación de métricas de producción en plantas manufactureras locales.',
    requestsCount: 0,
  },
]

const recentRequests = [
  {
    id: 101,
    problem: 'Optimización de rutas de distribución urbana',
    company: 'Logística Express S.A.S.',
    applicant: 'Andrés Quintero (UFPS)',
    status: 'Pendiente',
    date: 'Hoy',
  },
  {
    id: 102,
    problem: 'Módulo de analítica predictiva',
    company: 'EnergiCo del Oriente',
    applicant: 'Camila Torres (UFPS)',
    status: 'Aceptada',
    date: '22 Sep 2026',
  },
]
</script>

<template>
  <div class="flex min-h-screen bg-[#0D1B2E] text-[#EEF2FF]">
    <!-- Sidebar Navigation -->
    <aside
      class="w-64 flex flex-col shrink-0 border-r z-40 hidden md:flex min-h-screen"
      style="background: #0A1628; border-color: #1E3355;"
    >
      <!-- Top Logo -->
      <div class="px-5 py-5 border-b flex items-center justify-between" style="border-color: #1E3355;">
        <NuxtLink to="/">
          <Logo size="sm" />
        </NuxtLink>
      </div>

      <!-- Navigation Links -->
      <nav class="flex-1 px-3 py-4 space-y-1">
        <!-- Dashboard Item (Active) -->
        <div
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-semibold transition-all shadow-sm"
          style="background: linear-gradient(135deg, #1D3461 0%, #1A2E4A 100%); color: #60A5FA;"
        >
          <LayoutDashboard :size="16" class="text-blue-400" />
          <span class="flex-1">Dashboard</span>
        </div>

        <!-- Role-based items (Preview of platform features) -->
        <template v-if="isStudent">
          <div
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
            style="color: #6B8CAE;"
          >
            <Search :size="16" />
            <span class="flex-1">Explorar</span>
          </div>

          <div
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
            style="color: #6B8CAE;"
          >
            <FileText :size="16" />
            <span class="flex-1">Mis Solicitudes</span>
          </div>
        </template>
        <template v-else>
          <div
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
            style="color: #6B8CAE;"
          >
            <Briefcase :size="16" />
            <span class="flex-1">Problemáticas</span>
          </div>

          <div
            class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
            style="color: #6B8CAE;"
          >
            <Users :size="16" />
            <span class="flex-1">Solicitudes</span>
          </div>
        </template>

        <div
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
          style="color: #6B8CAE;"
        >
          <Bell :size="16" />
          <span class="flex-1">Notificaciones</span>
          <span class="text-[10px] font-bold px-1.5 py-0.5 rounded-full bg-blue-500 text-white">2</span>
        </div>

        <div
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all hover:bg-white/5 cursor-pointer opacity-75 hover:opacity-100"
          style="color: #6B8CAE;"
        >
          <User :size="16" />
          <span class="flex-1">Mi Perfil</span>
        </div>
      </nav>

      <!-- User Profile Card & Logout -->
      <div class="px-3 pb-5 space-y-3 border-t pt-4" style="border-color: #1E3355;">
        <div
          class="flex items-center gap-3 px-3 py-2.5 rounded-xl border"
          style="background: #122035; border-color: #1E3355;"
        >
          <div
            class="w-9 h-9 rounded-full flex items-center justify-center text-xs font-bold shrink-0 shadow-sm"
            style="background: linear-gradient(135deg, #3B82F6, #06B6D4); color: #fff;"
          >
            {{ userInitials }}
          </div>
          <div class="min-w-0 flex-1">
            <p class="text-xs font-semibold text-white truncate">{{ userDisplayName }}</p>
            <div class="flex items-center gap-1.5 mt-0.5">
              <span class="text-[10px] uppercase font-bold tracking-wider px-1.5 py-0.2 rounded bg-blue-500/20 text-blue-400">
                {{ user?.role || 'ESTUDIANTE' }}
              </span>
            </div>
          </div>
        </div>

        <button
          @click="handleLogout"
          class="w-full flex items-center justify-center gap-2 px-3 py-2 rounded-lg text-xs font-medium transition-colors hover:bg-red-500/10 hover:text-red-400 cursor-pointer"
          style="color: #6B8CAE;"
        >
          <LogOut :size="14" />
          <span>Cerrar sesión</span>
        </button>
      </div>
    </aside>

    <!-- Main Content Area -->
    <div class="flex-1 flex flex-col min-w-0 min-h-screen">
      <!-- Top Navigation Bar -->
      <header
        class="sticky top-0 z-30 flex items-center justify-between px-6 lg:px-8 h-16 border-b"
        style="background: rgba(13, 27, 46, 0.95); backdrop-filter: blur(8px); border-color: #1E3355;"
      >
        <div class="flex items-center gap-2 text-sm" style="color: #6B8CAE;">
          <div class="md:hidden flex items-center mr-2">
            <Logo size="sm" :show-text="false" />
          </div>
          <span class="font-medium text-slate-300">
            {{ isStudent ? 'Estudiante' : 'Empresa' }}
          </span>
          <ChevronRight :size="14" />
          <span class="text-white font-semibold">Dashboard</span>
        </div>

        <div class="flex items-center gap-4">
          <!-- Notification Bell -->
          <div class="relative p-2 rounded-lg hover:bg-white/5 transition-colors cursor-pointer" style="color: #6B8CAE;">
            <Bell :size="18" />
            <span class="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-blue-500" />
          </div>

          <!-- Mobile Logout Button -->
          <button
            @click="handleLogout"
            class="md:hidden p-2 rounded-lg text-slate-400 hover:text-red-400"
            title="Cerrar sesión"
          >
            <LogOut :size="18" />
          </button>
        </div>
      </header>

      <!-- Dashboard Body -->
      <main class="flex-1 p-6 lg:p-8 space-y-8 max-w-7xl w-full mx-auto">
        <!-- Welcome Hero -->
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <h1 class="text-2xl sm:text-3xl font-bold text-white mb-1.5" style="font-family: 'Plus Jakarta Sans', sans-serif;">
              {{ isStudent ? `¡Bienvenido, ${userDisplayName}! 👋` : `Panel Empresarial: ${userDisplayName}` }}
            </h1>
            <p class="text-xs sm:text-sm" style="color: #7B9CBF;">
              <template v-if="isStudent">
                Ingeniería de Sistemas · 8° semestre · Universidad Francisco de Paula Santander (UFPS)
              </template>
              <template v-else>
                Organización vinculada a la red de colaboración académica · Cúcuta, Norte de Santander
              </template>
            </p>
          </div>

          <div>
            <button
              v-if="isStudent"
              class="flex items-center gap-2 px-4 py-2.5 rounded-lg text-sm font-semibold text-white transition-all hover:opacity-90 shadow-glow-blue cursor-pointer"
              style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
            >
              <Search :size="15" />
              <span>Explorar problemáticas</span>
            </button>
            <button
              v-else
              class="flex items-center gap-2 px-4 py-2.5 rounded-lg text-sm font-semibold text-white transition-all hover:opacity-90 shadow-glow-blue cursor-pointer"
              style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
            >
              <Plus :size="15" />
              <span>Nueva problemática</span>
            </button>
          </div>
        </div>

        <!-- 4 Stats Cards Grid -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div
            v-for="(s, i) in (isStudent ? studentStats : companyStats)"
            :key="i"
            class="rounded-xl p-5 border transition-all hover:border-blue-500/40"
            style="background: #122035; border-color: #1E3355;"
          >
            <div class="flex items-center justify-between mb-3">
              <div
                class="w-9 h-9 rounded-lg flex items-center justify-center"
                :style="{ background: s.color + '18' }"
              >
                <component :is="s.Icon" :size="17" :style="{ color: s.color }" />
              </div>
            </div>
            <p class="text-2xl font-bold text-white">{{ s.value }}</p>
            <p class="text-xs mt-1" style="color: #7B9CBF;">{{ s.label }}</p>
          </div>
        </div>

        <!-- Main Content 5-Column Grid -->
        <div class="grid lg:grid-cols-5 gap-6">
          <!-- Left Column (3 cols) -->
          <div class="lg:col-span-3 space-y-4">
            <div class="flex items-center justify-between">
              <h2 class="text-base font-semibold text-white flex items-center gap-2">
                <Sparkles :size="16" style="color: #06B6D4;" />
                <span>{{ isStudent ? 'Problemáticas recomendadas' : 'Mis problemáticas publicadas' }}</span>
              </h2>
              <span class="text-xs font-medium cursor-pointer hover:underline" style="color: #3B82F6;">
                Ver todas →
              </span>
            </div>

            <!-- Student View: Problems List -->
            <div v-if="isStudent" class="space-y-3">
              <div
                v-for="p in studentFeaturedProblems"
                :key="p.id"
                class="rounded-xl p-5 border transition-all duration-200 hover:border-blue-500/40"
                style="background: #122035; border-color: #1E3355;"
              >
                <div class="flex items-start justify-between gap-3 mb-2">
                  <h3 class="font-semibold text-sm text-white leading-snug">{{ p.title }}</h3>
                  <StatusBadge :status="p.status" />
                </div>
                <div class="flex items-center gap-2 mb-3">
                  <div class="w-5 h-5 rounded text-[10px] font-bold flex items-center justify-center bg-blue-500/20 text-blue-400">
                    {{ p.company.charAt(0) }}
                  </div>
                  <span class="text-xs" style="color: #7B9CBF;">{{ p.company }} · {{ p.city }}</span>
                </div>
                <div class="flex flex-wrap gap-1.5">
                  <span
                    v-for="tag in p.tags"
                    :key="tag"
                    class="text-[11px] px-2 py-0.5 rounded"
                    style="background: #1A2E4A; color: #60A5FA;"
                  >
                    {{ tag }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Company View: My Problems -->
            <div v-else class="space-y-3">
              <div
                v-for="p in companyProblemsList"
                :key="p.id"
                class="rounded-xl p-5 border transition-all duration-200 hover:border-blue-500/40"
                style="background: #122035; border-color: #1E3355;"
              >
                <div class="flex items-start justify-between gap-3 mb-2">
                  <h3 class="font-semibold text-sm text-white leading-snug">{{ p.title }}</h3>
                  <StatusBadge :status="p.status" />
                </div>
                <p class="text-xs mb-3 line-clamp-2" style="color: #7B9CBF;">{{ p.desc }}</p>
                <div class="flex items-center gap-3 text-xs" style="color: #3B82F6;">
                  <span class="font-medium cursor-pointer hover:underline flex items-center gap-1">
                    Ver solicitudes ({{ p.requestsCount }}) <ArrowRight :size="12" />
                  </span>
                  <span style="color: #1E3355;">·</span>
                  <span class="cursor-pointer hover:underline" style="color: #6B8CAE;">Editar</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Column (2 cols) -->
          <div class="lg:col-span-2 space-y-4">
            <div class="flex items-center justify-between">
              <h2 class="text-base font-semibold text-white">
                {{ isStudent ? 'Mis solicitudes recientes' : 'Solicitudes recibidas' }}
              </h2>
              <span class="text-xs font-medium cursor-pointer hover:underline" style="color: #3B82F6;">
                Ver todas →
              </span>
            </div>

            <div class="space-y-3">
              <div
                v-for="r in recentRequests"
                :key="r.id"
                class="rounded-xl p-4 border"
                style="background: #122035; border-color: #1E3355;"
              >
                <div class="flex items-start justify-between gap-2 mb-1.5">
                  <h4 class="text-xs font-semibold text-white leading-snug">{{ r.problem }}</h4>
                  <StatusBadge :status="r.status" />
                </div>
                <p class="text-[11px]" style="color: #7B9CBF;">
                  {{ isStudent ? r.company : r.applicant }}
                </p>
                <div class="flex items-center justify-between mt-2 pt-2 border-t text-[10px]" style="border-color: #1E3355; color: #4A6B8A;">
                  <span>Enviada: {{ r.date }}</span>
                  <span class="text-blue-400 hover:underline cursor-pointer">Ver detalle</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Academic & Architecture Compliance Card (Validating auth-service) -->
        <div
          class="rounded-2xl p-6 border relative overflow-hidden"
          style="background: #0F1F36; border-color: #1E3355;"
        >
          <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-400">
                <ShieldCheck :size="22" />
              </div>
              <div>
                <h3 class="text-sm font-bold text-white flex items-center gap-2">
                  <span>Microservicio Piloto Fundacional: <code class="text-blue-400">auth-service</code></span>
                  <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                </h3>
                <p class="text-xs mt-0.5" style="color: #7B9CBF;">
                  Sesión SimpleJWT activa &bull; Resuelto desde <code class="text-xs text-slate-300">GET /api/v1/auth/me/</code> &bull; UFPS Cúcuta
                </p>
              </div>
            </div>

            <div class="flex flex-wrap items-center gap-3 text-xs">
              <div class="px-3 py-1.5 rounded-lg border flex items-center gap-2" style="background: #0D1B2E; border-color: #253D5F;">
                <span class="text-slate-400">Ley 1581 (Habeas Data):</span>
                <span :class="user?.habeas_data_consent ? 'text-emerald-400 font-semibold' : 'text-red-400'">
                  {{ user?.habeas_data_consent ? 'Autorizado' : 'Pendiente' }}
                </span>
              </div>
              <div class="px-3 py-1.5 rounded-lg border flex items-center gap-2" style="background: #0D1B2E; border-color: #253D5F;">
                <span class="text-slate-400">Email:</span>
                <span class="text-white font-mono">{{ user?.email }}</span>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>
