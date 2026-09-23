export default defineNuxtRouteMiddleware(async (to, from) => {
  if (import.meta.server) return

  const { isAuthenticated, initAuth } = useAuth()
  await initAuth()

  if (!isAuthenticated.value) {
    return navigateTo('/login')
  }
})
