# 可复用代码：定时任务注册

本目录包含引入 agentcore 后所需的**定时任务注册**实现，其他项目可直接复制到自己的 `core` app 下使用。

## 复制目标路径

| 本目录文件 | 复制到项目中的位置 |
|------------|--------------------|
| `periodic_registry.py` | `{SOURCE_PACKAGE}/core/periodic_registry.py` |
| `register_periodic_tasks.py` | `{SOURCE_PACKAGE}/core/management/commands/register_periodic_tasks.py` |

将 `{SOURCE_PACKAGE}` 替换为你的 Django 项目包名（如 `easy_divine`、`devmind`、`my_app`）。若主配置 app 不叫 `core`，请把 `core` 改为你的 app 名，并同步修改代码中的 `from core.periodic_registry import ...` 等导入。

## 依赖

- Django
- django-celery-beat

各 app（含 agentcore）需提供 `periodic_tasks` 模块并实现 `register_periodic_tasks()`，在其中通过 `from core.periodic_registry import TASK_REGISTRY` 调用 `TASK_REGISTRY.add(...)` 注册任务。  
`periodic_registry` 的语义是“**不存在则创建，已存在则完全跳过**”，这样数据库里手工调整过的 Beat 记录不会被启动流程覆盖。  
启动时在 entrypoint 中执行：`python manage.py register_periodic_tasks`（见 SKILL 的 entrypoint 小节）。
