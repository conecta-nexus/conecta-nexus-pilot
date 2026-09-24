<script setup lang="ts">
type StatusType =
  | 'Abierta'
  | 'En Proceso'
  | 'Cerrada'
  | 'Pendiente'
  | 'Aceptada'
  | 'Rechazada'

const props = defineProps<{
  status: StatusType | string
}>()

const config: Record<string, { bg: string; text: string; dot: string }> = {
  Abierta: { bg: 'bg-emerald-950/80 border border-emerald-800/50', text: 'text-emerald-400', dot: 'bg-emerald-400' },
  'En Proceso': { bg: 'bg-blue-950/80 border border-blue-800/50', text: 'text-blue-400', dot: 'bg-blue-400' },
  Cerrada: { bg: 'bg-slate-800/80 border border-slate-700/50', text: 'text-slate-400', dot: 'bg-slate-400' },
  Pendiente: { bg: 'bg-amber-950/80 border border-amber-800/50', text: 'text-amber-400', dot: 'bg-amber-400' },
  Aceptada: { bg: 'bg-emerald-950/80 border border-emerald-800/50', text: 'text-emerald-400', dot: 'bg-emerald-400' },
  Rechazada: { bg: 'bg-red-950/80 border border-red-800/50', text: 'text-red-400', dot: 'bg-red-400' },
}

const currentConfig = computed(() => {
  return config[props.status] || {
    bg: 'bg-slate-800 border border-slate-700',
    text: 'text-slate-300',
    dot: 'bg-slate-300',
  }
})
</script>

<template>
  <span
    :class="[
      'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium',
      currentConfig.bg,
      currentConfig.text
    ]"
  >
    <span :class="['w-1.5 h-1.5 rounded-full shrink-0', currentConfig.dot]" />
    {{ status }}
  </span>
</template>
