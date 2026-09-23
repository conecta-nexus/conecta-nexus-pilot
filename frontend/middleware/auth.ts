export default defineNuxtRouteMiddleware((to, from) => {
  if (import.meta.server) return

  const token = localStorage.getItem('conecta_access_token')
  if (!token) {
    return navigateTo('/login', { replace: true })
  }
})
