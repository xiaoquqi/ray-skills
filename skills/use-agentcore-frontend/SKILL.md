---
name: agentcore-frontend-style
description: >-
  Applies frontend style and UI design patterns from agentcore-based projects
  (Vue 3, Tailwind). Use when building or aligning admin consoles, task/LLM/alert
  UIs, or when the user mentions agentcore frontend, console UI, or admin
  design consistency.
---

# Agentcore 前端风格与 UI 设计逻辑

本 skill 提炼自使用 agentcore（task、metering、notifier）的 Vue 3 前端的通用风格与界面逻辑，便于在新项目中复用同一套设计体系。

## 复制到新项目时需要的目录

本 skill 在 **`code/`** 目录下维护了上述全部参考代码（与下表结构一致）。新项目可直接从 **本 skill 的 `code/`** 复制到自己的 `src/` 下，无需再从参考项目拷贝。以下路径均相对于**新项目**的项目根（即复制后文件落在 `src/` 下）。

### 新项目接入五步

1. **复制目录**：从本 skill 的 `code/` 下按下表把对应目录/文件拷到新项目的 `src/` 下（保持 `code/` 内结构与 `src/` 一致：`code/assets/css/` → `src/assets/css/`，`code/admin/` → `src/admin/`，`code/components/layout/` → `src/components/layout/`，`code/components/ui/` → `src/components/ui/`）。
2. **改 Console 路由**：编辑 `src/admin/routes.js`，把每条 route 的 `component` 改成新项目页面路径，按需改 `path`、`name`、`meta`。
3. **改侧栏菜单**：编辑 `src/admin/layout/AdminSidebar.vue` 和 `src/components/layout/AppSidebar.vue`，把菜单分组、`router-link` 的 `to`、以及 `t('...')` 的 key 改成新项目菜单。
4. **挂载 admin 路由**：在主路由（如 `src/router/index.js`）里 `import { adminRoutes } from '@/admin'`，在 routes 数组中用 `...adminRoutes` 展开。
5. **样式与构建**：入口（如 `main.js`）引入 `src/assets/css/main.css`；在 `tailwind.config.js` 的 `theme.extend` 中配置与 design tokens 对应的 colors、borderRadius、boxShadow、fontFamily（可参考参考项目）；确保构建配置了路径别名 `@` 指向 `src`。

### 要复制哪些（复制源 = 本 skill 的 `code/`，目标 = 新项目 `src/`）

| code/ 下路径 | 复制到新项目后 | 说明 |
|--------------|----------------|------|
| **`assets/css/`** | `src/assets/css/` | 必选。design-tokens.css + main.css，设计令牌与全局样式。 |
| **`admin/`** | `src/admin/` | 必选。layout/（AdminLayout、AdminHeader、AdminSidebar）、routes.js、index.js。Console 深色侧栏与路由。 |
| **`components/layout/`** | `src/components/layout/` | 必选。AppLayout、AppSidebar、AppHeader。浅色侧栏。 |
| **`components/ui/`** | `src/components/ui/` | 必选。BaseButton、BaseInput、BaseCard、BaseModal、BaseDrawer、BaseConfirmDialog、BaseLoading、StatusBadge、FilterDrawer、Toast、MarkdownRenderer、ErrorBoundary、LanguageSwitcher（可选）。 |

复制后需要在新项目里**按业务修改**的内容：

- **`src/admin/routes.js`**：保留结构，把每个 route 的 `component` 改成新项目的页面路径，必要时调整 `path`、`name`、`meta`。
- **`src/admin/layout/AdminSidebar.vue`**：保留布局与样式，把菜单项（分组、`router-link` 的 `to`、`t('...')` 的 key）改成新项目的 Console 菜单。
- **`src/components/layout/AppSidebar.vue`**：同上，改成新项目的 App 端菜单（含是否显示「管理后台」入口及链接到 `/console/...`）。
- **主路由**：在 `src/router/index.js`（或等价文件）里 `import { adminRoutes } from '@/admin'` 并用 `...adminRoutes` 展开到 routes 中。
- **入口样式**：主入口（如 `main.js`）引入 `src/assets/css/main.css`。
- **Tailwind**：在 `tailwind.config.js` 的 `theme.extend` 中配置与 design tokens 对应的变量（如 primary、surface、ink、border、radius、shadow、fontFamily），否则 `bg-primary-600` 等类不生效；可参考参考项目的 tailwind.config.js。
- **路径别名**：确保 Vite（或当前构建工具）的 `resolve.alias` 中 `@` 指向 `src`。

若新项目需要**任务列表/详情**等 agentcore-task 相关 UI，可再复制：`src/components/tasks/`（TaskCard、TaskDetailsModal 等）、`src/components/task-management/`（TaskConfigSection、TaskExecutionDetailPanel 等），按需裁剪。

不需要复制的：`src/pages/`、`src/api/`、业务相关组件（如 `cloud-billing/`、业务图标等）；新项目自建页面并引用上述布局与 UI 即可。管理页中可直接 `import AdminLayout from '@/admin/layout/AdminLayout.vue'` 包一层内容。

**维护**：本 skill 的 `code/` 以参考项目（如 easy-divine-ui）为源。当参考项目中上述目录有改动时，将对应文件同步回本 skill 的 `code/`，以保持模板最新。

## 1. 双布局体系

- **App 端**：用户主流程（如 dashboard、settings、tasks）。使用 `AppLayout`：浅色侧栏（`--color-surface-elevated`）、主色高亮（`primary`），路径如 `/dashboard`、`/app-settings/*`。
- **Console/Admin 端**：管理后台，路径统一为 `/console/*`，路由 `meta: { requiresAuth: true, requiresAdmin: true }`。使用 `AdminLayout`：深色侧栏（`--color-surface-inverse`）、白字 + 主色激活态。

布局结构一致：侧栏 + 顶栏 + 主内容区（`main` 内 `overflow-y-auto`，padding 如 `py-3 px-4`）。移动端：侧栏 `fixed` + 遮罩（`backdrop-filter: blur(4px)`），断点 `lg`（1024px）以上为静态侧栏。

## 2. 设计令牌（Design Tokens）

在 CSS 中维护单一来源（如 `design-tokens.css`），并在 `main.css` 的 `@layer base` / `@layer components` 中引用。

- **主色**：Primary 50–900（建议茶/琥珀系，如 `#f59e0b` 为 500），用于按钮、链接、激活态、焦点环。
- **表面**：`--color-surface`（页面底）、`--color-surface-elevated`（卡片/弹层）、`--color-surface-inverse`（深色侧栏）、`--color-surface-overlay`（遮罩）。
- **文字**：`--color-ink`、`--color-ink-muted`、`--color-ink-subtle`、`--color-ink-faint`。
- **边框**：`--color-border`、`--color-border-strong`；表单：`--color-input-bg`、`--color-input-ink`、`--color-input-border`、disabled 态。
- **圆角**：`--radius-sm` 到 `--radius-2xl`；阴影：`--shadow-soft`、`--shadow-soft-md`、`--shadow-soft-lg`。
- **字体**：`--font-display`、`--font-sans`（如 Inter + Noto Sans SC）。

所有按钮、输入框、卡片、弹层、表格统一使用上述变量，避免硬编码色值。

## 3. 页面结构逻辑

- **每页**：包一层对应 Layout（`AdminLayout` 或 App 的 Layout），再内层 `div` 做内容区。
- **页头**：`page-header`，含 `page-title`（如 `text-xl font-semibold`）+ 可选 `page-subtitle`（`text-sm text-gray-500`）。
- **列表/数据页**：
  - 顶部 **工具栏**：`admin-table-toolbar` 或等效：左侧批量操作，右侧搜索框 + 筛选按钮 + 刷新。使用 `BaseInput`（可带搜索 icon）、`BaseButton`（variant outline，size sm 用于刷新）。
  - **表格**：`<table class="data-table">`，`thead` 背景 `--color-surface`，`th` 小写+字重+边框；`tbody` 行 hover 变浅底，最后一列可放操作。数字列加 `data-table-cell-numeric`。
  - **移动端**：同一数据用卡片列表（如 `md:hidden` 下 card，`hidden md:block` 下 table）。
  - **空状态**：居中图标 + 文案，容器用浅底+圆角+边框。
  - **加载**：列表首次加载用 `BaseLoading`，避免布局跳动。

## 4. 通用组件约定

- **按钮**：`BaseButton`，variant：`primary` | `secondary` | `danger` | `outline` | `ghost`，size：`sm` | `md` | `lg`，支持 `loading`（旋转 icon + disabled）。
- **表单**：`BaseInput`（可插槽 icon），与 design tokens 的 input 背景/边框一致；错误态使用 `input-error` 或等效。
- **卡片**：`BaseCard`，slot：默认 body、可选 `header`/`footer`；支持 `title`、`padding`、`shadow`。
- **弹层**：
  - **Modal**：overlay（`dialog-overlay`）+ panel（`dialog-panel`），结构：`dialog-header`（标题 + 关闭）→ `dialog-body`（`dialog-body-inner`）→ 可选 `dialog-footer`（主操作在右，使用 `admin-dialog-actions`）。
  - **Drawer**：右侧滑出，header（标题 + 关闭）→ 可滚动内容；筛选类用 `FilterDrawer` 结构（表单项 + 应用/重置）。
  - **确认**：`BaseConfirmDialog`，标题 + 正文 + 取消/确认（危险操作用 danger 按钮）。
- **状态**：`StatusBadge`，status 如 success、failed、pending、processing、completed、enabled、disabled；样式为小圆角+背景+边框+可选 icon。
- **加载/空**：`BaseLoading` 全块或内联；空状态统一图标+一句说明。

## 5. 侧栏导航逻辑

- **分组**：`menu-group`，父项为可点击按钮（展开/收起），子项为 `router-link`。展开态用 `Transition`（opacity + max-height）。
- **激活**：`isActive(path)`：当前路由 `path.startsWith(path)` 或首页特殊处理；激活项用主色背景（Admin 深色栏用 `--color-primary-600`，App 浅色栏用 `bg-primary-50 text-primary-600`）。
- **子项缩进**：左侧留出空间（如 `pl-10`），可选左侧竖线（`::before`）表示层级，激活时竖线用主色。
- **持久化**：侧栏展开状态可存 `localStorage`，key 如 `sidebar_expanded_menus`，按 menuKey 存 boolean；路由变化时可根据当前 path 自动展开对应分组。

## 6. 路由与权限

- **Console**：所有 admin 路由放在同一数组（如 `adminRoutes`），路径前缀 `/console`，默认重定向到 `/console/users` 或首个子项。每个 route 的 component 内使用 `AdminLayout` 包一层。
- **App**：dashboard、settings、app-settings、tasks 等用主 App 布局；需管理员时 `meta.requiresAdmin: true`，在路由守卫或 layout 里根据 `user.is_staff` 判断。
- **入口**：App 侧栏/顶栏提供「管理后台」链接跳转 `/console/users`（或首条 console 路径）。

## 7. 与 agentcore 功能对应

- **任务**：用户端 `/tasks`（任务列表/详情），Console 端 `/console/task-management/list|stats|settings`。
- **计量/计费**：Console 下 token-stats、LLM usage、alerts（成本/用量统计与告警记录）。
- **通知**：Console `/console/alerts`：stats、channels、settings、rules、records；使用统一表格+筛选+StatusBadge。

新建 agentcore 相关页时：先确定是 App 还是 Console，选对应 Layout；再按「页头 → 工具栏 → 表格/卡片 + 空态 + 加载」和「弹层/抽屉」的组件约定实现，并统一使用 design tokens 与 Base* 组件。

## 8. 国际化

- 使用 vue-i18n，按模块拆分 locale：`common`、`admin`、`dashboard`、`taskManagement`、`llm`、`notificationManagement` 等。
- 侧栏菜单、表头、按钮、状态文案、错误信息均用 `t('key')`，便于多语言与后续维护。

## 参考

- 设计令牌与常用类名速查见 [reference.md](reference.md)。

## 快速检查清单

- [ ] 新页是否包在正确的 Layout（App vs Admin）下？
- [ ] 颜色/边框/圆角是否全部来自 design tokens？
- [ ] 列表页是否有 toolbar + data-table + 移动端卡片 + 空态 + Loading？
- [ ] 弹层是否使用 dialog-* 类或 BaseModal/BaseDrawer？
- [ ] 侧栏激活态与展开态是否与路由同步？
- [ ] 文案是否走 i18n？
