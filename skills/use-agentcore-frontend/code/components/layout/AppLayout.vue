<template>
  <div class="h-screen bg-surface flex w-full overflow-hidden">
    <!-- Sidebar -->
    <AppSidebar
      :show-mobile-menu="showMobileMenu"
      @close="showMobileMenu = false"
    />

    <!-- Main content area -->
    <div class="flex-1 flex flex-col min-w-0 w-0 h-full overflow-hidden">
      <!-- Header -->
      <AppHeader @toggle-menu="showMobileMenu = !showMobileMenu" />

      <main class="flex-1 min-w-0 overflow-y-auto bg-surface">
        <div class="app-content" :key="route.path">
          <slot />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from './AppHeader.vue'
import AppSidebar from './AppSidebar.vue'

const showMobileMenu = ref(false)
const route = useRoute()
</script>
