export interface UserProfile {
  id: number
  email: string
  role: 'ESTUDIANTE' | 'EMPRESA' | 'ADMIN'
  habeas_data_consent: boolean
  consent_date: string | null
  date_joined?: string
  is_active?: boolean
}

export interface RegisterPayload {
  email: string
  password: string
  role: 'ESTUDIANTE' | 'EMPRESA'
  habeas_data_consent: boolean
}

export const useAuth = () => {
  const config = useRuntimeConfig()
  const router = useRouter()

  const apiBase = config.public.apiBase || 'http://localhost:8000'

  const user = useState<UserProfile | null>('auth_user', () => null)
  const accessToken = useState<string | null>('auth_access_token', () => null)
  const refreshToken = useState<string | null>('auth_refresh_token', () => null)
  const isLoading = useState<boolean>('auth_loading', () => false)
  const errorMessage = useState<string | null>('auth_error', () => null)
  const isInitialized = useState<boolean>('auth_initialized', () => false)

  const isAuthenticated = computed(() => !!accessToken.value)

  // Synchronize state with localStorage in browser
  const initAuth = async () => {
    if (import.meta.server) return

    if (!isInitialized.value) {
      const storedAccess = localStorage.getItem('conecta_access_token')
      const storedRefresh = localStorage.getItem('conecta_refresh_token')
      const storedUser = localStorage.getItem('conecta_user_profile')

      if (storedAccess) {
        accessToken.value = storedAccess
      }
      if (storedRefresh) {
        refreshToken.value = storedRefresh
      }
      if (storedUser) {
        try {
          user.value = JSON.parse(storedUser)
        } catch {
          user.value = null
        }
      }

      isInitialized.value = true

      // Verify token freshness against backend /me/
      if (accessToken.value) {
        await fetchMe()
      }
    }
  }

  // Register a new student or enterprise account
  const register = async (payload: RegisterPayload) => {
    isLoading.value = true
    errorMessage.value = null

    try {
      if (!payload.habeas_data_consent) {
        throw new Error(
          'Debe autorizar el tratamiento de sus datos personales según la Ley 1581 de 2012 (Habeas Data) para continuar.'
        )
      }

      const response = await $fetch<{ message: string; user: UserProfile }>(
        `${apiBase}/api/v1/auth/register/`,
        {
          method: 'POST',
          body: payload,
          headers: {
            'Content-Type': 'application/json',
          },
        }
      )

      return { success: true, data: response }
    } catch (err: any) {
      const backendError =
        err?.data?.habeas_data_consent?.[0] ||
        err?.data?.email?.[0] ||
        err?.data?.password?.[0] ||
        err?.data?.detail ||
        err?.message ||
        'Error al procesar el registro.'
      errorMessage.value = backendError
      return { success: false, error: backendError }
    } finally {
      isLoading.value = false
    }
  }

  // Log in with email and password
  const login = async (email: string, password: string) => {
    isLoading.value = true
    errorMessage.value = null

    try {
      const response = await $fetch<{
        access: string
        refresh: string
        user_id: number
        email: string
        role: 'ESTUDIANTE' | 'EMPRESA' | 'ADMIN'
        habeas_data_consent: boolean
        consent_date: string | null
      }>(`${apiBase}/api/v1/auth/login/`, {
        method: 'POST',
        body: { email, password },
        headers: {
          'Content-Type': 'application/json',
        },
      })

      accessToken.value = response.access
      refreshToken.value = response.refresh
      user.value = {
        id: response.user_id,
        email: response.email,
        role: response.role,
        habeas_data_consent: response.habeas_data_consent,
        consent_date: response.consent_date,
      }

      if (import.meta.client) {
        localStorage.setItem('conecta_access_token', response.access)
        localStorage.setItem('conecta_refresh_token', response.refresh)
        localStorage.setItem('conecta_user_profile', JSON.stringify(user.value))
      }

      await router.push('/dashboard')
      return { success: true }
    } catch (err: any) {
      const backendError =
        err?.data?.detail ||
        err?.data?.non_field_errors?.[0] ||
        err?.message ||
        'Credenciales inválidas. Por favor verifique correo y contraseña.'
      errorMessage.value = backendError
      return { success: false, error: backendError }
    } finally {
      isLoading.value = false
    }
  }

  // Fetch full user profile from protected endpoint /api/v1/auth/me/
  const fetchMe = async (): Promise<boolean> => {
    if (!accessToken.value) {
      return false
    }

    try {
      const profile = await $fetch<UserProfile>(`${apiBase}/api/v1/auth/me/`, {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${accessToken.value}`,
        },
      })

      user.value = profile
      if (import.meta.client) {
        localStorage.setItem('conecta_user_profile', JSON.stringify(profile))
      }
      return true
    } catch (err: any) {
      if (err?.status === 401 || err?.statusCode === 401) {
        const refreshed = await refreshTokens()
        if (refreshed) {
          return await fetchMe()
        }
        await logout()
      }
      return false
    }
  }

  // Refresh expired access token using refresh token
  const refreshTokens = async (): Promise<boolean> => {
    if (!refreshToken.value) {
      return false
    }

    try {
      const response = await $fetch<{ access: string }>(
        `${apiBase}/api/v1/auth/refresh/`,
        {
          method: 'POST',
          body: { refresh: refreshToken.value },
          headers: {
            'Content-Type': 'application/json',
          },
        }
      )

      accessToken.value = response.access
      if (import.meta.client) {
        localStorage.setItem('conecta_access_token', response.access)
      }
      return true
    } catch {
      return false
    }
  }

  // Destroy session locally and redirect to /login
  const logout = async () => {
    user.value = null
    accessToken.value = null
    refreshToken.value = null
    errorMessage.value = null

    if (import.meta.client) {
      localStorage.removeItem('conecta_access_token')
      localStorage.removeItem('conecta_refresh_token')
      localStorage.removeItem('conecta_user_profile')
    }

    await router.push('/login')
  }

  return {
    user,
    accessToken,
    refreshToken,
    isLoading,
    errorMessage,
    isAuthenticated,
    initAuth,
    register,
    login,
    fetchMe,
    logout,
  }
}
