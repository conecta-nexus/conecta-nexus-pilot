<script setup lang="ts">
definePageMeta({
  middleware: [
    async () => {
      const { isAuthenticated, initAuth } = useAuth()
      await initAuth()
      if (isAuthenticated.value) {
        return navigateTo('/dashboard')
      }
      return navigateTo('/login')
    }
  ]
})
</script>

<template>
  <div class="flex items-center justify-center min-h-[60vh]">
    <div class="text-center space-y-4">
      <div class="inline-block w-8 h-8 border-4 border-ufps-600 border-t-transparent rounded-full animate-spin"></div>
      <p class="text-sm text-slate-400">Redirigiendo a Conecta Nexus...</p>
    </div>
  </div>
</template>
