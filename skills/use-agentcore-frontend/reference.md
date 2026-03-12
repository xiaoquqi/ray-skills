# Agentcore 前端风格 — 参考

## 复制目录速查（来源 = 本 skill 的 `code/`，目标 = 新项目 `src/`）

| code/ 下 | 复制到 | 必选 |
|----------|--------|------|
| `assets/css/` | `src/assets/css/` | ✅ |
| `admin/` | `src/admin/` | ✅ |
| `components/layout/` | `src/components/layout/` | ✅ |
| `components/ui/` | `src/components/ui/` | ✅ |
| （参考项目）`components/tasks/` | `src/components/tasks/` | 按需 |
| （参考项目）`components/task-management/` | `src/components/task-management/` | 按需 |

复制后需改：`admin/routes.js` 的 component/path、`AdminSidebar.vue` / `AppSidebar.vue` 的菜单项、主路由挂载 `...adminRoutes`、入口引入 `main.css`、`tailwind.config.js` 的 theme.extend、路径别名 `@` 指向 `src`。

## Design Tokens 变量速查

```css
/* Primary */
--color-primary-50 ... --color-primary-900

/* Surfaces */
--color-surface
--color-surface-elevated
--color-surface-overlay
--color-surface-inverse
--color-surface-inverse-hover
--color-surface-inverse-border

/* Ink */
--color-ink
--color-ink-muted
--color-ink-subtle
--color-ink-faint

/* Border & Input */
--color-border
--color-border-strong
--color-input-bg
--color-input-ink
--color-input-border
--color-input-disabled-bg
--color-input-disabled-ink

/* Radii & Shadows */
--radius-sm | --radius-md | --radius-lg | --radius-xl | --radius-2xl
--shadow-soft | --shadow-soft-md | --shadow-soft-lg

/* Font */
--font-display
--font-sans
```

## 常用 Tailwind/Component 类名

| 用途       | 类名 |
|------------|------|
| 页容器     | `page-content`、`max-w-7xl mx-auto` |
| 页标题     | `page-title`、`page-subtitle` |
| 工具栏     | `admin-table-toolbar` |
| 表格       | `data-table`、`data-table-cell-muted`、`data-table-cell-numeric` |
| 弹层       | `dialog-overlay`、`dialog-panel`、`dialog-header`、`dialog-body`、`dialog-footer`、`admin-dialog-actions` |
| 卡片       | `card`、`card-header`、`card-body`、`card-footer`、`page-card` |
| 按钮       | `btn`、`btn-primary`、`btn-secondary`、`btn-danger`、`btn-outline`、`btn-ghost` |
| 设置页     | `settings-page`、`settings-tabs`、`settings-tab`、`settings-tab-active`、`settings-card`、`settings-row` |

## 侧栏类名（Admin 深色）

- 父项：`admin-nav-item`、`admin-nav-item-parent`
- 子项：`admin-nav-item-child`
- 激活：`admin-nav-item-active`
- 分组：`menu-group`、`submenu`

## 侧栏类名（App 浅色）

- 项：`nav-item`、`nav-item-parent`、`nav-item-child`、`nav-item-active`
- 分组：`menu-group`、`submenu`
