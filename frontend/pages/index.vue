<script setup lang="ts">
import { 
  ArrowRight, 
  Building2, 
  GraduationCap, 
  Lightbulb, 
  CheckCircle2, 
  Users, 
  Zap 
} from 'lucide-vue-next'

const { isAuthenticated, initAuth } = useAuth()

onMounted(async () => {
  await initAuth()
})

const steps = [
  { n: '01', Icon: Building2, title: 'Empresa publica', desc: 'La organización describe su problemática o necesidad real con contexto detallado.' },
  { n: '02', Icon: GraduationCap, title: 'Estudiante explora', desc: 'El universitario navega las problemáticas disponibles y encuentra una que se alinea con su perfil académico.' },
  { n: '03', Icon: Lightbulb, title: 'Solicita contacto', desc: 'El estudiante manifiesta su interés con una motivación académica justificada.' },
  { n: '04', Icon: CheckCircle2, title: 'Empresa decide', desc: 'La empresa evalúa la solicitud y acepta o rechaza según el perfil del solicitante.' },
  { n: '05', Icon: Users, title: 'Se habilita el contacto', desc: 'Si la solicitud es aceptada, el sistema habilita el contacto directo entre ambas partes.' },
]

const studentBenefits = [
  'Accede a problemáticas reales de empresas activas.',
  'Aplica tu formación académica en contextos empresariales.',
  'Fortalece tu perfil profesional y portafolio.',
  'Desarrolla relaciones con el sector productivo.',
]

const companyBenefits = [
  'Conecta con talento universitario fresco y motivado.',
  'Plantea problemas reales y recibe propuestas académicas.',
  'Proceso estructurado de evaluación de candidatos.',
  'Impulsa la transferencia de conocimiento universidad–empresa.',
]

const scrollToSection = (id: string) => {
  const el = document.getElementById(id)
  if (el) {
    el.scrollIntoView({ behavior: 'smooth' })
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#0D1B2E] text-[#EEF2FF] flex flex-col selection:bg-blue-500 selection:text-white">
    <!-- Fixed Public Header -->
    <header
      class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-12 h-16 border-b transition-all duration-200"
      style="background: rgba(13, 27, 46, 0.92); backdrop-filter: blur(12px); border-color: #253D5F;"
    >
      <NuxtLink to="/" class="flex items-center">
        <Logo size="md" />
      </NuxtLink>

      <nav class="hidden md:flex items-center gap-6 text-sm font-medium" style="color: #7B9CBF;">
        <NuxtLink to="/" class="hover:text-white transition-colors">Inicio</NuxtLink>
        <button @click="scrollToSection('flujo')" class="hover:text-white transition-colors cursor-pointer">
          Cómo funciona
        </button>
      </nav>

      <div class="flex items-center gap-3">
        <template v-if="isAuthenticated">
          <NuxtLink
            to="/dashboard"
            class="text-sm font-semibold px-4 py-2 rounded-lg transition-colors flex items-center gap-1.5"
            style="background: #3B82F6; color: #fff;"
          >
            Ir al Dashboard
            <ArrowRight :size="14" />
          </NuxtLink>
        </template>
        <template v-else>
          <NuxtLink
            to="/login"
            class="text-sm font-medium px-4 py-2 rounded-lg transition-colors hover:text-white"
            style="color: #94A3B8;"
          >
            Iniciar sesión
          </NuxtLink>
          <NuxtLink
            to="/register"
            class="text-sm font-semibold px-4 py-2 rounded-lg transition-colors hover:opacity-90"
            style="background: #3B82F6; color: #fff;"
          >
            Registrarse
          </NuxtLink>
        </template>
      </div>
    </header>

    <!-- Main Content -->
    <main class="pt-16 flex-grow">
      <!-- Hero Section -->
      <section class="relative min-h-[90vh] flex flex-col items-center justify-center px-6 text-center overflow-hidden">
        <!-- Ambient background glows -->
        <div
          class="absolute top-1/3 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] rounded-full opacity-10 blur-3xl pointer-events-none"
          style="background: radial-gradient(circle, #3B82F6 0%, transparent 70%);"
        />
        <div
          class="absolute top-2/3 right-1/4 w-[300px] h-[300px] rounded-full opacity-5 blur-3xl pointer-events-none"
          style="background: radial-gradient(circle, #06B6D4 0%, transparent 70%);"
        />

        <!-- Grid pattern overlay -->
        <div
          class="absolute inset-0 opacity-[0.03] pointer-events-none"
          style="background-image: linear-gradient(#fff 1px, transparent 1px), linear-gradient(90deg, #fff 1px, transparent 1px); background-size: 60px 60px;"
        />

        <div class="relative max-w-4xl mx-auto py-12">
          <!-- Tag Pill -->
          <div
            class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium mb-8 border"
            style="background: #122035; border-color: #253D5F; color: #60A5FA;"
          >
            <Zap :size="12" />
            <span>Plataforma académica · UFPS · Proyecto semestral</span>
          </div>

          <!-- Centered Large Logo -->
          <div class="flex justify-center mb-8">
            <Logo size="lg" />
          </div>

          <!-- Main Title with Gradients -->
          <h1
            class="text-4xl sm:text-6xl lg:text-7xl font-extrabold mb-6 leading-tight tracking-tight"
            style="font-family: 'Plus Jakarta Sans', sans-serif;"
          >
            El puente entre 
            <span
              style="background: linear-gradient(135deg, #3B82F6, #06B6D4); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"
            >
              la academia
            </span> 
            y la 
            <span
              style="background: linear-gradient(135deg, #06B6D4, #8B5CF6); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"
            >
              empresa
            </span>
          </h1>

          <!-- Subtitle -->
          <p class="text-base sm:text-lg lg:text-xl mb-10 max-w-2xl mx-auto leading-relaxed" style="color: #7B9CBF;">
            Conecta Nexus vincula estudiantes universitarios con organizaciones a través de problemáticas reales,
            generando colaboración académica con impacto empresarial.
          </p>

          <!-- Action Buttons -->
          <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
            <NuxtLink
              to="/register"
              class="flex items-center gap-2 px-8 py-3.5 rounded-xl font-semibold text-white transition-all hover:opacity-90 hover:scale-105 shadow-glow-blue"
              style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
            >
              Comenzar ahora
              <ArrowRight :size="18" />
            </NuxtLink>
            <button
              @click="scrollToSection('flujo')"
              class="flex items-center gap-2 px-8 py-3.5 rounded-xl font-semibold border transition-all hover:bg-white/5 cursor-pointer"
              style="border-color: #253D5F; color: #94A3B8;"
            >
              Cómo funciona
            </button>
          </div>

          <!-- Stats Strip -->
          <div
            class="flex items-center justify-center gap-6 sm:gap-12 mt-14 pt-10 border-t"
            style="border-color: #1E3355;"
          >
            <div class="text-center">
              <p class="text-2xl sm:text-3xl font-bold text-white">4+</p>
              <p class="text-xs mt-1" style="color: #6B8CAE;">Empresas activas</p>
            </div>
            <div class="w-px h-10" style="background: #1E3355;" />
            <div class="text-center">
              <p class="text-2xl sm:text-3xl font-bold text-white">18+</p>
              <p class="text-xs mt-1" style="color: #6B8CAE;">Problemáticas publicadas</p>
            </div>
            <div class="w-px h-10" style="background: #1E3355;" />
            <div class="text-center">
              <p class="text-2xl sm:text-3xl font-bold text-white">95%</p>
              <p class="text-xs mt-1" style="color: #6B8CAE;">Tasa de satisfacción</p>
            </div>
          </div>
        </div>
      </section>

      <!-- System Flow Section -->
      <section id="flujo" class="py-20 px-6" style="background: #080F1E;">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <p class="text-xs font-semibold tracking-widest uppercase mb-3" style="color: #3B82F6;">
              FLUJO DEL SISTEMA
            </p>
            <h2 class="text-3xl sm:text-4xl font-bold text-white" style="font-family: 'Plus Jakarta Sans', sans-serif;">
              Simple. Estructurado. Efectivo.
            </h2>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-4">
            <div v-for="(s, i) in steps" :key="i" class="relative group">
              <div
                class="rounded-xl p-5 h-full flex flex-col border transition-all duration-200 hover:border-blue-500/50"
                style="background: #0F1F36; border-color: #1E3355;"
              >
                <div class="flex items-center gap-2 mb-3">
                  <span class="text-xs font-mono font-bold" style="color: #3B82F6;">{{ s.n }}</span>
                  <component :is="s.Icon" :size="16" style="color: #06B6D4;" />
                </div>
                <h3 class="text-sm font-semibold text-white mb-2">{{ s.title }}</h3>
                <p class="text-xs leading-relaxed" style="color: #6B8CAE;">{{ s.desc }}</p>
              </div>

              <!-- Connecting arrow for desktop -->
              <div
                v-if="i < steps.length - 1"
                class="hidden md:flex absolute top-1/2 -right-2.5 -translate-y-1/2 z-10"
              >
                <ArrowRight :size="14" style="color: #253D5F;" />
              </div>
            </div>
          </div>

          <div class="text-center mt-10">
            <NuxtLink
              to="/register"
              class="text-sm font-medium transition-colors hover:text-white inline-flex items-center gap-1"
              style="color: #3B82F6;"
            >
              Comienza registrando tu perfil →
            </NuxtLink>
          </div>
        </div>
      </section>

      <!-- Benefits Section -->
      <section class="py-20 px-6">
        <div class="max-w-6xl mx-auto grid md:grid-cols-2 gap-8 sm:gap-10">
          <!-- Students Card -->
          <div
            class="rounded-2xl p-8 border transition-all hover:border-blue-500/40"
            style="background: #0F1F36; border-color: #1E3355;"
          >
            <div
              class="w-12 h-12 rounded-xl flex items-center justify-center mb-5"
              style="background: linear-gradient(135deg, #3B82F6, #06B6D4);"
            >
              <GraduationCap :size="22" class="text-white" />
            </div>
            <h3 class="text-2xl font-bold text-white mb-2" style="font-family: 'Plus Jakarta Sans', sans-serif;">
              Para estudiantes
            </h3>
            <p class="text-sm mb-6" style="color: #7B9CBF;">
              Conéctate con el mundo empresarial desde tu formación académica.
            </p>
            <ul class="space-y-3">
              <li v-for="(b, i) in studentBenefits" :key="i" class="flex items-start gap-3 text-sm" style="color: #94A3B8;">
                <CheckCircle2 :size="16" class="text-emerald-400 mt-0.5 shrink-0" />
                <span>{{ b }}</span>
              </li>
            </ul>
            <NuxtLink
              to="/register"
              class="inline-flex items-center gap-2 mt-6 px-5 py-2.5 rounded-lg font-semibold text-sm transition-colors hover:opacity-90"
              style="background: #3B82F6; color: #fff;"
            >
              Registrarme como estudiante
              <ArrowRight :size="15" />
            </NuxtLink>
          </div>

          <!-- Companies Card -->
          <div
            class="rounded-2xl p-8 border transition-all hover:border-purple-500/40"
            style="background: #0F1F36; border-color: #1E3355;"
          >
            <div
              class="w-12 h-12 rounded-xl flex items-center justify-center mb-5"
              style="background: linear-gradient(135deg, #8B5CF6, #06B6D4);"
            >
              <Building2 :size="22" class="text-white" />
            </div>
            <h3 class="text-2xl font-bold text-white mb-2" style="font-family: 'Plus Jakarta Sans', sans-serif;">
              Para empresas
            </h3>
            <p class="text-sm mb-6" style="color: #7B9CBF;">
              Accede a talento universitario para resolver necesidades reales de tu organización.
            </p>
            <ul class="space-y-3">
              <li v-for="(b, i) in companyBenefits" :key="i" class="flex items-start gap-3 text-sm" style="color: #94A3B8;">
                <CheckCircle2 :size="16" class="text-cyan-400 mt-0.5 shrink-0" />
                <span>{{ b }}</span>
              </li>
            </ul>
            <NuxtLink
              to="/register"
              class="inline-flex items-center gap-2 mt-6 px-5 py-2.5 rounded-lg font-semibold text-sm transition-colors border hover:bg-purple-950/20"
              style="border-color: #8B5CF6; color: #A78BFA;"
            >
              Registrar mi empresa
              <ArrowRight :size="15" />
            </NuxtLink>
          </div>
        </div>
      </section>

      <!-- CTA Box -->
      <section class="py-20 px-6" style="background: #080F1E;">
        <div
          class="max-w-3xl mx-auto rounded-2xl p-8 sm:p-12 text-center border relative overflow-hidden"
          style="background: #0F1F36; border-color: #253D5F;"
        >
          <div
            class="absolute top-0 left-1/2 -translate-x-1/2 w-64 h-32 opacity-20 blur-2xl pointer-events-none"
            style="background: radial-gradient(ellipse, #3B82F6, transparent);"
          />
          <h2 class="text-2xl sm:text-3xl font-bold text-white mb-4" style="font-family: 'Plus Jakarta Sans', sans-serif;">
            ¿Listo para conectar?
          </h2>
          <p class="mb-8 text-sm sm:text-base max-w-xl mx-auto leading-relaxed" style="color: #7B9CBF;">
            Únete a Conecta Nexus y sé parte de la red que une la academia con el sector productivo en Norte de Santander.
          </p>
          <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
            <NuxtLink
              to="/register"
              class="w-full sm:w-auto px-8 py-3.5 rounded-xl font-semibold text-white transition-all hover:opacity-90"
              style="background: linear-gradient(135deg, #3B82F6, #2563EB);"
            >
              Crear cuenta gratuita
            </NuxtLink>
            <NuxtLink
              to="/login"
              class="w-full sm:w-auto px-8 py-3.5 rounded-xl font-semibold border transition-all hover:bg-white/5"
              style="border-color: #253D5F; color: #94A3B8;"
            >
              Ya tengo cuenta
            </NuxtLink>
          </div>
        </div>
      </section>
    </main>

    <!-- Global Footer -->
    <footer class="py-8 border-t text-center text-xs" style="background: #080F1E; border-color: #1E3355; color: #4A6B8A;">
      <div class="max-w-6xl mx-auto px-6 flex flex-col sm:flex-row items-center justify-between gap-4">
        <div class="flex items-center gap-2">
          <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span>Microservicio Piloto <strong class="text-slate-300">auth-service</strong> &bull; Conecta Nexus</span>
        </div>
        <div>
          <span>Universidad Francisco de Paula Santander (UFPS - Cúcuta) &bull; Ley 1581 de 2012</span>
        </div>
      </div>
    </footer>
  </div>
</template>
