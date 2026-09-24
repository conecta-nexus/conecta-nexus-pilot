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
          bg: '#080F1E',
          surface: '#0D1B2E',
          sidebar: '#0A1628',
          card: '#0F1F36',
          panel: '#122035',
          selected: '#1A2E4A',
          border: '#1E3355',
          'border-light': '#253D5F',
          muted: '#4A6B8A',
          subtext: '#6B8CAE',
          body: '#7B9CBF',
          text: '#EEF2FF',
          blue: '#3B82F6',
          cyan: '#06B6D4',
          purple: '#8B5CF6',
        }
      },
      fontFamily: {
        sans: ['"Plus Jakarta Sans"', 'system-ui', '-apple-system', 'sans-serif'],
      },
      boxShadow: {
        'glow-blue': '0 4px 24px rgba(59, 130, 246, 0.3)',
        'glow-cyan': '0 4px 24px rgba(6, 182, 212, 0.25)',
        'glow-card': '0 10px 30px -10px rgba(0, 0, 0, 0.5)',
      }
    }
  }
}
