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
    />
  </Transition>

  <aside
    :class="[
      'admin-sidebar flex flex-col transition-transform duration-300 ease-in-out w-64 flex-shrink-0 h-full border-r',
      isMobile ? 'fixed inset-y-0 left-0 z-50' : 'static',
      isMobile && !showMobileMenu ? '-translate-x-full' : 'translate-x-0'
    ]"
    style="background-color: var(--color-surface-inverse); border-color: var(--color-surface-inverse-border);"
  >
    <div
      class="flex items-center justify-between h-16 px-4 border-b"
      style="border-color: var(--color-surface-inverse-border);"
    >
      <router-link
        to="/console/users"
        class="flex items-center space-x-2 flex-1"
        @click="isMobile && $emit('close')"
      >
        <img
          src="/android-chrome-192x192.png"
          :alt="t('management.logoTitle')"
          class="w-8 h-8"
        />
        <span class="text-xl font-semibold text-white font-display">{{
          t('management.logoTitle')
        }}</span>
      </router-link>
      <button
        v-if="isMobile"
        type="button"
        @click="$emit('close')"
        class="p-2 rounded-md text-gray-400 hover:text-white hover:bg-surface-inverse-hover"
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
      <div class="menu-group">
        <button
          type="button"
          class="admin-nav-item admin-nav-item-parent w-full"
          @click="toggleMenu('adminUserGroup')"
        >
          <svg
            class="w-5 h-5 flex-shrink-0"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
            />
          </svg>
          <span class="flex-1 text-left">{{
            t('common.menu.adminUserGroup')
          }}</span>
          <svg
            class="w-4 h-4 ml-1 transition-transform duration-200 flex-shrink-0"
            :class="adminUserGroup ? 'rotate-90' : ''"
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
          <div v-show="adminUserGroup" class="submenu">
            <router-link
              to="/console/users"
              class="admin-nav-item admin-nav-item-child"
              :class="isActive('/console/users') ? 'admin-nav-item-active' : ''"
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
                />
              </svg>
              <span>{{ t('common.menu.adminUsers') }}</span>
            </router-link>
            <router-link
              to="/console/groups"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/groups') ? 'admin-nav-item-active' : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                />
              </svg>
              <span>{{ t('common.menu.adminGroups') }}</span>
            </router-link>
          </div>
        </Transition>
      </div>

      <div class="menu-group">
        <button
          type="button"
          class="admin-nav-item admin-nav-item-parent w-full"
          @click="toggleMenu('adminLLMManagement')"
        >
          <svg
            class="w-5 h-5 flex-shrink-0"
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
          <span class="flex-1 text-left">{{ t('llm.menuTitle') }}</span>
          <svg
            class="w-4 h-4 ml-1 transition-transform duration-200 flex-shrink-0"
            :class="adminLLMManagement ? 'rotate-90' : ''"
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
          <div v-show="adminLLMManagement" class="submenu">
            <router-link
              to="/console/llm/stats"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/llm/stats') ? 'admin-nav-item-active' : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <span>{{ t('llm.stats.title') }}</span>
            </router-link>
            <router-link
              to="/console/llm/usage"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/llm/usage') ? 'admin-nav-item-active' : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
                />
              </svg>
              <span>{{ t('llm.usage.title') }}</span>
            </router-link>
            <router-link
              to="/console/llm/config"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/llm/config') ? 'admin-nav-item-active' : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
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
              <span>{{ t('llm.config.title') }}</span>
            </router-link>
            <router-link
              to="/console/llm/data-settings"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/llm/data-settings')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <span>{{ t('llm.dataSettings.title') }}</span>
            </router-link>
          </div>
        </Transition>
      </div>

      <div class="menu-group">
        <button
          type="button"
          class="admin-nav-item admin-nav-item-parent w-full"
          @click="toggleMenu('adminTaskManagement')"
        >
          <svg
            class="w-5 h-5 flex-shrink-0"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
            />
          </svg>
          <span class="flex-1 text-left">{{
            t('taskManagement.menuTitle')
          }}</span>
          <svg
            class="w-4 h-4 ml-1 transition-transform duration-200 flex-shrink-0"
            :class="adminTaskManagement ? 'rotate-90' : ''"
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
          <div v-show="adminTaskManagement" class="submenu">
            <router-link
              to="/console/task-management/list"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/task-management/list')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
                />
              </svg>
              <span>{{ t('taskManagement.list.title') }}</span>
            </router-link>
            <router-link
              to="/console/task-management/stats"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/task-management/stats')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <span>{{ t('taskManagement.stats.title') }}</span>
            </router-link>
            <router-link
              to="/console/task-management/settings"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/task-management/settings')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
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
              <span>{{ t('taskManagement.settings.title') }}</span>
            </router-link>
          </div>
        </Transition>
      </div>

      <div class="menu-group">
        <button
          type="button"
          class="admin-nav-item admin-nav-item-parent w-full"
          @click="toggleMenu('adminNotificationManagement')"
        >
          <svg
            class="w-5 h-5 flex-shrink-0"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
            />
          </svg>
          <span class="flex-1 text-left">{{
            t('notificationManagement.menuTitle')
          }}</span>
          <svg
            class="w-4 h-4 ml-1 transition-transform duration-200 flex-shrink-0"
            :class="adminNotificationManagement ? 'rotate-90' : ''"
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
          <div v-show="adminNotificationManagement" class="submenu">
            <router-link
              to="/console/alerts/stats"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/alerts/stats') ? 'admin-nav-item-active' : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <span>{{ t('notificationManagement.stats.title') }}</span>
            </router-link>
            <router-link
              to="/console/alerts/notifier-records"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/alerts/notifier-records')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 10h16M4 14h16M4 18h16"
                />
              </svg>
              <span>{{ t('notificationManagement.records.title') }}</span>
            </router-link>
            <router-link
              to="/console/alerts/channels"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/alerts/channels')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"
                />
              </svg>
              <span>{{ t('notificationManagement.channels.menuTitle') }}</span>
            </router-link>
            <router-link
              to="/console/alerts/settings"
              class="admin-nav-item admin-nav-item-child"
              :class="
                isActive('/console/alerts/settings')
                  ? 'admin-nav-item-active'
                  : ''
              "
              @click="isMobile && $emit('close')"
            >
              <svg
                class="w-4 h-4 flex-shrink-0"
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
              <span>{{ t('notificationManagement.settings.menuTitle') }}</span>
            </router-link>
          </div>
        </Transition>
      </div>

      <div class="mt-auto pt-4 border-t space-y-1" style="border-color: var(--color-surface-inverse-border);"></div>
    </nav>
  </aside>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'

defineProps({
  showMobileMenu: { type: Boolean, default: false }
})
defineEmits(['close'])

const { t } = useI18n()
const route = useRoute()

const adminUserGroup = ref(true)
const adminLLMManagement = ref(true)
const adminTaskManagement = ref(true)
const adminNotificationManagement = ref(true)

const isMobile = computed(() => {
  if (typeof window === 'undefined') return false
  return window.innerWidth < 1024
})

function isActive(path) {
  if (path === '/dashboard')
    return route.path === '/dashboard' || route.path === '/'
  return route.path.startsWith(path)
}

function toggleMenu(menuKey) {
  const refs = {
    adminUserGroup,
    adminLLMManagement,
    adminTaskManagement,
    adminNotificationManagement
  }
  const r = refs[menuKey]
  if (r) r.value = !r.value
}

function setOpenFromPath() {
  const path = route.path
  if (path.startsWith('/console/users') || path.startsWith('/console/groups'))
    adminUserGroup.value = true
  if (path.startsWith('/console/llm')) adminLLMManagement.value = true
  if (path.startsWith('/console/task-management'))
    adminTaskManagement.value = true
  if (path.startsWith('/console/alerts'))
    adminNotificationManagement.value = true
}

watch(() => route.path, setOpenFromPath, { immediate: true })
</script>

<style scoped>
.admin-nav-item {
  @apply flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-200;
  color: rgba(255, 255, 255, 0.8);
}

.admin-nav-item:hover {
  background-color: var(--color-surface-inverse-hover);
  color: #fff;
}

.admin-nav-item-active {
  @apply text-white;
  background-color: var(--color-primary-600);
}

.admin-nav-item-active:hover {
  background-color: var(--color-primary-600);
  color: #fff;
}

.admin-nav-item-parent {
  @apply w-full cursor-pointer font-semibold;
  color: rgba(255, 255, 255, 0.9);
}

.admin-nav-item-parent:hover {
  background-color: var(--color-surface-inverse-hover);
  color: #fff;
}

.admin-nav-item-parent.admin-nav-item-active {
  @apply text-white;
  background-color: var(--color-primary-600);
}

.admin-nav-item-parent.admin-nav-item-active:hover {
  background-color: var(--color-primary-600);
  color: #fff;
}

.admin-nav-item-child {
  @apply relative pl-10 py-2 text-sm font-normal;
  margin-left: 0.75rem;
  border-radius: 0.375rem;
  color: rgba(255, 255, 255, 0.65);
}

.admin-nav-item-child:hover {
  background-color: var(--color-surface-inverse-hover);
  color: rgba(255, 255, 255, 0.9);
}

.admin-nav-item-child.admin-nav-item-active {
  @apply text-white font-medium;
  background-color: var(--color-primary-600);
}

.admin-nav-item-child::before {
  content: '';
  @apply absolute left-6 top-1/2 -translate-y-1/2 w-0.5 h-5 rounded;
  background-color: var(--color-surface-inverse-border);
  transition: all 0.2s;
}

.admin-nav-item-child.admin-nav-item-active::before {
  @apply w-1;
  background-color: var(--color-primary-400);
}

.menu-group {
  @apply space-y-0 mb-1.5;
}

.submenu {
  @apply overflow-hidden pl-0 mt-1 space-y-0.5;
  transition: all 0.2s ease-in-out;
}

.submenu .admin-nav-item {
  @apply ml-0;
}

.admin-nav-item-parent svg:first-child {
  @apply flex-shrink-0;
}

.admin-nav-item-parent span {
  @apply flex-shrink-0;
}

.admin-nav-item-parent svg:last-child {
  @apply flex-shrink-0 ml-1 opacity-70;
  transition:
    transform 0.2s ease-in-out,
    opacity 0.2s;
}

.admin-nav-item-parent:hover svg:last-child {
  @apply opacity-100;
}
</style>
