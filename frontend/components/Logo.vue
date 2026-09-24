<script setup lang="ts">
interface Props {
  size?: 'sm' | 'md' | 'lg'
  showText?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  showText: true
})

const dim = computed(() => {
  return { sm: 26, md: 34, lg: 44 }[props.size]
})

const textClass = computed(() => {
  return { sm: 'text-sm', md: 'text-base', lg: 'text-xl' }[props.size]
})
</script>

<template>
  <div class="flex items-center gap-2.5 select-none">
    <svg :width="dim" :height="dim" viewBox="0 0 34 34" fill="none" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="cn-logo-grad" x1="3" y1="31" x2="31" y2="3" gradientUnits="userSpaceOnUse">
          <stop stop-color="#3B82F6" />
          <stop offset="1" stop-color="#06B6D4" />
        </linearGradient>
      </defs>
      <circle cx="6" cy="28" r="4.5" fill="url(#cn-logo-grad)" />
      <circle cx="28" cy="6" r="4.5" fill="url(#cn-logo-grad)" />
      <circle cx="28" cy="28" r="3" fill="url(#cn-logo-grad)" opacity="0.45" />
      <path
        d="M6 28L6 6L28 28L28 6"
        stroke="url(#cn-logo-grad)"
        stroke-width="2.8"
        stroke-linecap="round"
        stroke-linejoin="round"
        fill="none"
      />
    </svg>
    <span
      v-if="showText"
      :class="['font-bold tracking-tight', textClass]"
      style="font-family: 'Plus Jakarta Sans', sans-serif;"
    >
      <span class="text-white">Conecta</span><span class="text-cyan-400">Nexus</span>
    </span>
  </div>
</template>
