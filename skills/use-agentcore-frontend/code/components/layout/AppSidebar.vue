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
        <div class="my-2 border-t" style="border-color: var(--color-border);"></div>
        <div class="menu-group">
          <button
            type="button"
            class="nav-item nav-item-parent w-full"
            @click="toggleMenu('adminMiniappSettings')"
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
                d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
              />
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
              />
            </svg>
            <span class="flex-1 text-left">{{
              t('common.menu.adminMiniappSettings')
            }}</span>
            <svg
              class="w-4 h-4 transition-transform"
              :class="expandedMenus.adminMiniappSettings ? 'rotate-90' : ''"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5l7 7-7 7"
              />
            </svg>
          </button>
          <Transition
            enter-active-class="transition-all duration-200 ease-out"
            enter-from-class="opacity-0 max-h-0"
            enter-to-class="opacity-100 max-h-96"
            leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="opacity-100 max-h-96"
            leave-to-class="opacity-0 max-h-0"
          >
            <div v-show="expandedMenus.adminMiniappSettings" class="submenu">
              <router-link
                to="/app-settings/general"
                class="nav-item nav-item-child"
                :class="
                  isActive('/app-settings/general') ? 'nav-item-active' : ''
                "
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                  />
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
                <span>{{ t('admin.miniappSettings.menuGeneral') }}</span>
              </router-link>
              <router-link
                to="/app-settings/prompts"
                class="nav-item nav-item-child"
                :class="
                  isActive('/app-settings/prompts') ? 'nav-item-active' : ''
                "
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                <span>{{ t('admin.miniappSettings.menuPrompts') }}</span>
              </router-link>
              <router-link
                to="/app-settings/llm"
                class="nav-item nav-item-child"
                :class="isActive('/app-settings/llm') ? 'nav-item-active' : ''"
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"
                  />
                </svg>
                <span>{{ t('admin.miniappSettings.menuLLM') }}</span>
              </router-link>
            </div>
          </Transition>
        </div>
        <div class="menu-group">
          <button
            type="button"
            class="nav-item nav-item-parent w-full"
            @click="toggleMenu('adminStaticData')"
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
                d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
              />
            </svg>
            <span class="flex-1 text-left">{{
              t('common.menu.adminStaticData')
            }}</span>
            <svg
              class="w-4 h-4 transition-transform"
              :class="expandedMenus.adminStaticData ? 'rotate-90' : ''"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5l7 7-7 7"
              />
            </svg>
          </button>
          <Transition
            enter-active-class="transition-all duration-200 ease-out"
            enter-from-class="opacity-0 max-h-0"
            enter-to-class="opacity-100 max-h-96"
            leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="opacity-100 max-h-96"
            leave-to-class="opacity-0 max-h-0"
          >
            <div v-show="expandedMenus.adminStaticData" class="submenu">
              <router-link
                to="/console/categories"
                class="nav-item nav-item-child"
                :class="
                  isActive('/console/categories') ? 'nav-item-active' : ''
                "
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
                  />
                </svg>
                <span>{{ t('common.menu.adminCategories') }}</span>
              </router-link>
              <router-link
                to="/console/common-questions"
                class="nav-item nav-item-child"
                :class="
                  isActive('/console/common-questions') ? 'nav-item-active' : ''
                "
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                  />
                </svg>
                <span>{{ t('common.menu.adminCommonQuestions') }}</span>
              </router-link>
            </div>
          </Transition>
        </div>
        <div class="menu-group">
          <button
            type="button"
            class="nav-item nav-item-parent w-full"
            @click="toggleMenu('adminRecordsGroup')"
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
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            <span class="flex-1 text-left">{{
              t('common.menu.adminRecordsGroup')
            }}</span>
            <svg
              class="w-4 h-4 transition-transform"
              :class="expandedMenus.adminRecordsGroup ? 'rotate-90' : ''"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 5l7 7-7 7"
              />
            </svg>
          </button>
          <Transition
            enter-active-class="transition-all duration-200 ease-out"
            enter-from-class="opacity-0 max-h-0"
            enter-to-class="opacity-100 max-h-96"
            leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="opacity-100 max-h-96"
            leave-to-class="opacity-0 max-h-0"
          >
            <div v-show="expandedMenus.adminRecordsGroup" class="submenu">
              <router-link
                to="/console/question-analyze"
                class="nav-item nav-item-child"
                :class="
                  isActive('/console/question-analyze') ? 'nav-item-active' : ''
                "
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                  />
                </svg>
                <span>{{ t('common.menu.adminQuestionAnalyze') }}</span>
              </router-link>
              <router-link
                to="/console/records"
                class="nav-item nav-item-child"
                :class="isActive('/console/records') ? 'nav-item-active' : ''"
                @click="isMobile && $emit('close')"
              >
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                <span>{{ t('common.menu.adminRecords') }}</span>
              </router-link>
            </div>
          </Transition>
        </div>
      </div>
    </nav>
  </aside>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useUserStore } from '@/store/user'

defineProps({
  showMobileMenu: { type: Boolean, default: false }
})
defineEmits(['close'])

const { t } = useI18n()
const route = useRoute()
const userStore = useUserStore()

const isAdmin = computed(() => userStore.userInfo?.is_staff === true)

const expandedMenus = ref({
  adminMiniappSettings: true,
  adminStaticData: true,
  adminRecordsGroup: true,
  adminLLMManagement: true,
  adminTaskManagement: true
})

const STORAGE_KEY = 'sidebar_expanded_menus'

function loadExpandedState() {
  if (typeof window === 'undefined') return
  const saved = localStorage.getItem(STORAGE_KEY)
  if (saved) {
    try {
      expandedMenus.value = { ...expandedMenus.value, ...JSON.parse(saved) }
    } catch {
      // ignore parse errors
    }
  }
}

function saveExpandedState() {
  if (typeof window === 'undefined') return
  localStorage.setItem(STORAGE_KEY, JSON.stringify(expandedMenus.value))
}

function toggleMenu(menuKey) {
  expandedMenus.value[menuKey] = !expandedMenus.value[menuKey]
  saveExpandedState()
}

const isMobile = computed(() => {
  if (typeof window === 'undefined') return false
  return window.innerWidth < 1024
})

function isActive(path) {
  if (path === '/dashboard')
    return route.path === '/dashboard' || route.path === '/'
  return route.path.startsWith(path)
}

function isParentActive(children) {
  if (!children || !children.length) return false
  return children.some((child) => isActive(child.path))
}

watch(
  () => route.path,
  () => {
    if (
      isParentActive([
        { path: '/app-settings/general' },
        { path: '/app-settings/prompts' },
        { path: '/app-settings/llm' }
      ])
    ) {
      expandedMenus.value.adminMiniappSettings = true
    }
    if (
      isParentActive([
        { path: '/console/categories' },
        { path: '/console/common-questions' }
      ])
    ) {
      expandedMenus.value.adminStaticData = true
    }
    if (
      isParentActive([
        { path: '/console/records' },
        { path: '/console/question-analyze' }
      ])
    ) {
      expandedMenus.value.adminRecordsGroup = true
    }
  },
  { immediate: true }
)

onMounted(() => {
  loadExpandedState()
})
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
