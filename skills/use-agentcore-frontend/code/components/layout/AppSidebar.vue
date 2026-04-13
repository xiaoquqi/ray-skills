<template>
  <Transition
    enter-active-class="transition-opacity duration-200"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition-opacity duration-150"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-if="showMobileMenu && isMobile"
      @click="$emit('close')"
      class="fixed inset-0 z-40 lg:hidden"
      style="background-color: var(--color-surface-overlay); backdrop-filter: blur(4px);"
    ></div>
  </Transition>

  <aside
    :class="[
      'app-sidebar flex flex-col transition-transform duration-300 ease-in-out w-64 flex-shrink-0 h-full border-r',
      isMobile ? 'fixed inset-y-0 left-0 z-50' : 'static',
      isMobile && !showMobileMenu ? '-translate-x-full' : 'translate-x-0'
    ]"
    style="background-color: var(--color-surface-elevated); border-color: var(--color-border); box-shadow: 2px 0 12px rgba(0,0,0,0.04);"
  >
    <div
      class="flex items-center justify-between h-16 px-4 border-b"
      style="border-color: var(--color-border);"
    >
      <router-link
        to="/dashboard"
        class="flex items-center space-x-2 flex-1"
        @click="isMobile && $emit('close')"
      >
        <img
          src="/android-chrome-192x192.png"
          alt="Easy Divine"
          class="w-8 h-8"
        />
        <span class="text-xl font-semibold font-display" style="color: var(--color-ink);">{{
          t('common.appName')
        }}</span>
      </router-link>
      <button
        v-if="isMobile"
        @click="$emit('close')"
        class="p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100"
      >
        <svg
          class="w-5 h-5"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M6 18L18 6M6 6l12 12"
          />
        </svg>
      </button>
    </div>

    <nav class="flex-1 px-3 py-4 space-y-1 overflow-y-auto flex flex-col">
      <router-link
        to="/dashboard"
        class="nav-item"
        :class="isActive('/dashboard') ? 'nav-item-active' : ''"
        @click="isMobile && $emit('close')"
      >
        <svg
          class="w-5 h-5"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
          />
        </svg>
        <span>{{ t('common.menu.dashboard') }}</span>
      </router-link>

      <div v-if="isAdmin" class="space-y-1">
        <!-- Application admin items moved to AdminSidebar -->
      </div>
    </nav>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'

defineProps({
  showMobileMenu: { type: Boolean, default: false }
})
defineEmits(['close'])

const { t } = useI18n()
const route = useRoute()

const isMobile = computed(() => {
  if (typeof window === 'undefined') return false
  return window.innerWidth < 1024
})

function isActive(path) {
  if (path === '/dashboard')
    return route.path === '/dashboard' || route.path === '/'
  return route.path.startsWith(path)
}
</script>

<style scoped>
.nav-item {
  @apply flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-all duration-200;
}

.nav-item-active {
  @apply bg-primary-50 text-primary-600;
}

.nav-item-parent {
  @apply w-full cursor-pointer font-semibold text-gray-800;
}

.nav-item-parent:hover {
  @apply bg-gray-50;
}

.nav-item-parent.nav-item-active {
  @apply bg-primary-50 text-primary-600;
}

.nav-item-child {
  @apply relative pl-10 py-2 text-sm font-normal text-gray-600;
  margin-left: 0.75rem;
  border-radius: 0.375rem;
}

.nav-item-child:hover {
  @apply bg-gray-50;
}

.nav-item-child.nav-item-active {
  @apply bg-primary-50 text-primary-600 font-medium;
}

.menu-group {
  @apply space-y-0 mb-1.5;
}

.submenu {
  @apply overflow-hidden pl-0 mt-1 space-y-0.5;
  transition: all 0.2s ease-in-out;
}

.submenu .nav-item {
  @apply ml-0;
}

.nav-item-child::before {
  content: '';
  @apply absolute left-6 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-gray-300 rounded;
  transition: all 0.2s;
}

.nav-item-child.nav-item-active::before {
  @apply bg-primary-500 w-1;
}

.nav-item-parent svg:first-child {
  @apply flex-shrink-0;
}

.nav-item-parent span {
  @apply flex-shrink-0;
}

.nav-item-parent svg:last-child {
  @apply flex-shrink-0 ml-1 opacity-70;
  transition:
    transform 0.2s ease-in-out,
    opacity 0.2s;
}

.nav-item-parent:hover svg:last-child {
  @apply opacity-100;
}
</style>
