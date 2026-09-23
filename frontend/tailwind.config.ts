import type { Config } from 'tailwindcss'

export default <Partial<Config>>{
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        ufps: {
          50: '#fdf3f2',
          100: '#fbe4e3',
          200: '#f7cdcb',
          300: '#f0aaa7',
          400: '#e57a75',
          500: '#d7524c',
          600: '#aa1916', // Official UFPS Red
          700: '#8f1412',
          800: '#771412',
          900: '#641614',
          950: '#370706',
        },
        nexus: {
          dark: '#0B0F19',
          card: '#111827',
          border: '#1F2937',
          accent: '#3B82F6',
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'system-ui', '-apple-system', 'sans-serif'],
      },
      boxShadow: {
        'glow-red': '0 0 25px -5px rgba(170, 25, 22, 0.35)',
        'glow-blue': '0 0 25px -5px rgba(59, 130, 246, 0.35)',
      }
    }
  }
}
