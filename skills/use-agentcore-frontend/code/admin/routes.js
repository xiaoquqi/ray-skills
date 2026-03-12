/**
 * Admin (console) routes. Mount with ...adminRoutes in the main router.
 * All paths under /console; each page uses AdminLayout from @/admin/layout.
 */
export const adminRoutes = [
  { path: '/console', redirect: '/console/users' },
  {
    path: '/console/users',
    name: 'AdminUsers',
    component: () => import('@/pages/admin/AdminUsers.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/groups',
    name: 'AdminGroups',
    component: () => import('@/pages/admin/AdminGroups.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/tasks',
    name: 'AdminTasks',
    component: () => import('@/pages/admin/AdminTasks.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/token-stats',
    name: 'AdminTokenStats',
    component: () => import('@/pages/admin/AdminTokenStats.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/question-analyze',
    name: 'AdminQuestionAnalyze',
    component: () => import('@/pages/admin/AdminQuestionAnalyze.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/records',
    name: 'AdminRecords',
    component: () => import('@/pages/admin/AdminRecords.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/common-questions',
    name: 'AdminCommonQuestions',
    component: () => import('@/pages/admin/AdminCommonQuestions.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/categories',
    name: 'AdminCategories',
    component: () => import('@/pages/admin/AdminCategories.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/time-ranges',
    name: 'AdminTimeRanges',
    component: () => import('@/pages/admin/AdminTimeRanges.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/llm-usage',
    name: 'AdminLLMUsage',
    component: () => import('@/pages/admin/AdminLLMUsage.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/miniapp-settings',
    redirect: '/console/miniapp-settings/general'
  },
  {
    path: '/console/miniapp-settings/general',
    name: 'AdminMiniappSettingsGeneral',
    component: () => import('@/pages/admin/AdminMiniappSettings.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/miniapp-settings/prompts',
    name: 'AdminMiniappSettingsPrompts',
    component: () =>
      import('@/pages/admin/miniapp-settings/MiniappSettingsPrompts.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/miniapp-settings/llm',
    name: 'AdminMiniappSettingsLLM',
    component: () =>
      import('@/pages/admin/miniapp-settings/MiniappSettingsLLM.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/miniapp-settings/task-runtime',
    name: 'AdminMiniappSettingsTaskRuntime',
    component: () =>
      import('@/pages/admin/miniapp-settings/MiniappSettingsTaskRuntime.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  { path: '/console/llm', redirect: '/console/llm/stats' },
  {
    path: '/console/llm/stats',
    name: 'LLMStats',
    component: () => import('@/pages/admin/llm/Stats.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/llm/usage',
    name: 'LLMUsage',
    component: () => import('@/pages/admin/llm/Usage.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/llm/config',
    name: 'LLMConfig',
    component: () => import('@/pages/admin/llm/Config.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/llm/data-settings',
    name: 'LLMDataSettings',
    component: () => import('@/pages/admin/llm/DataSettings.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/task-management',
    redirect: '/console/task-management/list'
  },
  {
    path: '/console/task-management/list',
    name: 'TaskManagementList',
    component: () => import('@/pages/admin/task-management/List.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/task-management/stats',
    name: 'TaskManagementStats',
    component: () => import('@/pages/admin/task-management/Stats.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/task-management/settings',
    name: 'TaskManagementSettings',
    component: () => import('@/pages/admin/task-management/Settings.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  { path: '/console/alerts', redirect: '/console/alerts/stats' },
  {
    path: '/console/alerts/records',
    name: 'AdminAlertsRecords',
    component: () => import('@/pages/admin/alerts/Records.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/alerts/notifier-records',
    name: 'AdminNotificationsRecords',
    component: () => import('@/pages/admin/alerts/NotifierRecords.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/alerts/stats',
    name: 'AdminNotificationsStats',
    component: () => import('@/pages/admin/alerts/Stats.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/alerts/channels',
    name: 'AdminNotificationsChannels',
    component: () => import('@/pages/admin/alerts/Channels.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/alerts/settings',
    name: 'AdminNotificationsSettings',
    component: () => import('@/pages/admin/alerts/Settings.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/console/alerts/rules',
    name: 'AdminAlertsRules',
    component: () => import('@/pages/admin/alerts/Rules.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  }
]
