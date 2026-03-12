<template>
  <header
    class="flex-shrink-0 z-30 border-b"
    style="background-color: var(--color-surface-inverse); border-color: var(--color-surface-inverse-border);"
  >
    <div class="px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <div class="flex items-center gap-3">
          <button
            type="button"
            @click="$emit('toggle-menu')"
            class="lg:hidden p-2 rounded-md text-gray-400 hover:text-white hover:bg-surface-inverse-hover focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <svg
              class="w-6 h-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"
              />
            </svg>
          </button>
          <h1 class="text-lg font-semibold text-white lg:max-w-md truncate font-display">
            {{ pageTitle }}
          </h1>
        </div>

        <div class="flex items-center space-x-4 admin-header-actions">
          <router-link
            to="/dashboard"
            class="text-sm font-medium text-gray-300 hover:text-white px-3 py-1.5 rounded-md hover:bg-surface-inverse-hover transition-colors"
          >
            {{ t('management.backToAppAdmin') }}
          </router-link>
          <LanguageSwitcher />
          <div class="relative" ref="userMenuRef">
            <button
              type="button"
              @click="toggleUserMenu"
              class="flex items-center space-x-2 text-sm text-gray-200 hover:text-white focus:outline-none focus:ring-2 focus:ring-primary-500 rounded-lg px-2 py-1"
            >
              <div
                :class="avatarBgColor"
                class="w-8 h-8 rounded-full flex items-center justify-center"
              >
                <span class="text-white font-medium text-sm">
                  {{ userInitials }}
                </span>
              </div>
              <span class="hidden sm:block">{{ displayName }}</span>
              <svg
                class="w-4 h-4 transition-transform text-gray-400"
                :class="{ 'rotate-180': showUserMenu }"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>

            <Transition
              enter-active-class="transition ease-out duration-100"
              enter-from-class="transform opacity-0 scale-95"
              enter-to-class="transform opacity-100 scale-100"
              leave-active-class="transition ease-in duration-75"
              leave-from-class="transform opacity-100 scale-100"
              leave-to-class="transform opacity-0 scale-95"
            >
              <div
                v-if="showUserMenu"
                class="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-soft-lg py-2 z-50 border border-border"
              >
                <div class="px-4 py-2 border-b border-border">
                  <div class="font-semibold text-ink truncate">
                    {{ displayName }}
                  </div>
                </div>
                <router-link
                  to="/settings"
                  class="flex items-center gap-2 text-sm text-ink-muted hover:bg-gray-100 rounded-md px-4 py-2 transition-colors"
                  @click="showUserMenu = false"
                >
                  <span>{{ t('common.settings') }}</span>
                </router-link>
                <div class="border-t border-border my-1" />
                <button
                  type="button"
                  @click="handleLogout"
                  class="block w-full text-left px-4 py-2 text-sm text-ink-muted hover:bg-gray-100"
                >
                  {{ t('common.logout') }}
                </button>
              </div>
            </Transition>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useUserStore } from '@/store/user'
import LanguageSwitcher from '@/components/ui/LanguageSwitcher.vue'

defineEmits(['toggle-menu'])

const { t } = useI18n()
const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const showUserMenu = ref(false)
const userMenuRef = ref(null)

const routeNameToTitle = {
  AdminUsers: () => t('common.menu.adminUsers'),
  AdminGroups: () => t('common.menu.adminGroups'),
  AdminMiniappSettingsGeneral: () => t('common.menu.adminMiniappSettings'),
  AdminMiniappSettingsPrompts: () => t('admin.miniappSettings.menuPrompts'),
  AdminMiniappSettingsLLM: () => t('admin.miniappSettings.menuLLM'),
  AdminMiniappSettingsTaskRuntime: () =>
    t('admin.miniappSettings.menuTaskRuntime'),
  AdminCategories: () => t('common.menu.adminCategories'),
  AdminCommonQuestions: () => t('common.menu.adminCommonQuestions'),
  AdminQuestionAnalyze: () => t('common.menu.adminQuestionAnalyze'),
  AdminRecords: () => t('common.menu.adminRecords'),
  LLMStats: () => t('llm.stats.title'),
  LLMUsage: () => t('llm.usage.title'),
  LLMConfig: () => t('llm.config.title'),
  LLMDataSettings: () => t('llm.dataSettings.title'),
  TaskManagementList: () => t('taskManagement.list.title'),
  TaskManagementStats: () => t('taskManagement.stats.title'),
  TaskManagementSettings: () => t('taskManagement.settings.title'),
  AdminAlertsRecords: () => t('cloudBilling.alerts.title'),
  AdminAlertsRules: () => t('cloudBilling.alerts.rules.title'),
  AdminNotificationsStats: () => t('notificationManagement.stats.title'),
  AdminNotificationsRecords: () => t('notificationManagement.records.title'),
  AdminNotificationsChannels: () =>
    t('notificationManagement.channels.menuTitle'),
  AdminNotificationsSettings: () =>
    t('notificationManagement.settings.menuTitle')
}

const pageTitle = computed(() => {
  const name = route.name
  const fn = routeNameToTitle[name]
  return fn ? fn() : t('management.logoTitle')
})

const displayName = computed(() => {
  const userInfo = userStore.userInfo
  if (!userInfo) return 'User'
  if (userInfo.display_name) return userInfo.display_name
  if (userInfo.first_name && userInfo.last_name)
    return `${userInfo.first_name} ${userInfo.last_name}`
  if (userInfo.first_name) return userInfo.first_name
  return userInfo.username || 'User'
})

const userInitials = computed(() => {
  const name = displayName.value
  const firstChar = name.trim().charAt(0).toUpperCase()
  return firstChar || 'U'
})

const avatarBgColor = computed(() => {
  const colors = [
    'bg-primary-500',
    'bg-primary-600',
    'bg-primary-700',
    'bg-gray-600',
    'bg-gray-700'
  ]
  const initial = userInitials.value
  const charCode = initial.charCodeAt(0)
  const colorIndex = charCode % colors.length
  return colors[colorIndex]
})

function toggleUserMenu() {
  showUserMenu.value = !showUserMenu.value
}

async function handleLogout() {
  try {
    await userStore.logout()
  } catch (err) {
    console.error('Logout failed:', err)
  } finally {
    showUserMenu.value = false
    router.push('/login')
  }
}

function handleClickOutside(event) {
  if (userMenuRef.value && !userMenuRef.value.contains(event.target)) {
    showUserMenu.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
.admin-header-actions :deep(button) {
  @apply text-gray-400 hover:text-white hover:bg-surface-inverse-hover;
}
</style>
