<script setup lang="ts">
// Main root application wrapper
</script>

<template>
  <div class="min-h-screen bg-slate-950 text-slate-100 flex flex-col relative overflow-x-hidden">
    <!-- Ambient background light effects -->
    <div class="fixed inset-0 pointer-events-none z-0 overflow-hidden">
      <div class="absolute -top-40 -left-40 w-96 h-96 bg-ufps-600/15 rounded-full blur-3xl"></div>
      <div class="absolute top-1/3 -right-40 w-96 h-96 bg-blue-600/10 rounded-full blur-3xl"></div>
      <div class="absolute -bottom-40 left-1/3 w-96 h-96 bg-emerald-600/10 rounded-full blur-3xl"></div>
      <!-- Subtle grid overlay -->
      <div class="absolute inset-0 bg-[linear-gradient(to_right,#1f293710_1px,transparent_1px),linear-gradient(to_bottom,#1f293710_1px,transparent_1px)] bg-[size:4rem_4rem]"></div>
    </div>

    <!-- Main router view -->
    <main class="flex-grow z-10 flex flex-col">
      <NuxtPage />
    </main>

    <!-- Global footer -->
    <footer class="z-10 py-6 border-t border-slate-800/60 text-center text-xs text-slate-500">
      <div class="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-2">
        <div class="flex items-center gap-2">
          <span class="inline-block w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span>Microservicio Piloto <strong class="text-slate-300">auth-service</strong> &bull; Conecta Nexus</span>
        </div>
        <div>
          <span>Universidad Francisco de Paula Santander (UFPS - Cúcuta) &bull; Ley 1581 de 2012</span>
        </div>
      </div>
    </footer>
  </div>
</template>
