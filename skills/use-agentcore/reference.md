# Agentcore 引入参考细节

与 [SKILL.md](SKILL.md) 配套，供需要逐项对照或迁移时查阅。

## .gitmodules 示例

agentcore 必须在**源码包路径下**，例如：

```ini
[submodule "easy_divine/agentcore/agentcore-metering"]
	path = easy_divine/agentcore/agentcore-metering
	url = https://github.com/cloud2ai/agentcore-metering.git
[submodule "easy_divine/agentcore/agentcore-task"]
	path = easy_divine/agentcore/agentcore-task
	url = https://github.com/cloud2ai/agentcore-task.git
[submodule "easy_divine/agentcore/agentcore-notifier"]
	path = easy_divine/agentcore/agentcore-notifier
	url = https://github.com/cloud2ai/agentcore-notifier.git
```

其他项目将 `easy_divine` 替换为各自的源码包名（如 `devmind`、`my_app`）。

## pyproject.toml 依赖

生产与 CI 仍从 GitHub 安装，保留：

```toml
dependencies = [
    ...
    "agentcore-metering @ git+https://github.com/cloud2ai/agentcore-metering.git",
    "agentcore-task @ git+https://github.com/cloud2ai/agentcore-task.git",
    "agentcore-notifier @ git+https://github.com/cloud2ai/agentcore-notifier.git",
]
```

研发镜像在 `DEV_MODE=1` 时用镜像内拷贝的 agentcore 做 `pip install -e` 覆盖上述安装；运行时若挂载了源码目录，则直接使用宿主机 agentcore。

## Dockerfile 片段（研发模式安装）

在「COPY 源码目录」和「安装主依赖」之后增加：

```dockerfile
# Dev mode: overlay agentcore from image copy in editable mode.
ARG DEV_MODE=0
RUN set -eux; \
    if [ "$DEV_MODE" = "1" ]; then \
        for d in /opt/YOUR_PACKAGE/agentcore/*/; do \
            if [ -f "${d}pyproject.toml" ]; then \
                echo "Dev mode: pip install -e $d"; \
                (cd "$d" && pip install -e .); \
            fi; \
        done; \
    fi
```

若使用 uv：`(cd "$d" && uv pip install --system -e .)`。`/opt/YOUR_PACKAGE` 与 `WORKDIR` 及 COPY 目标一致。

## docker-compose 对照

| 文件 | DEV_MODE | 挂载源码 |
|------|----------|----------|
| docker-compose.dev.yml | `"1"` | 是，如 `./easy_divine:/opt/easy_divine` |
| docker-compose.yml（生产） | `"0"` | 否 |

## 子模块路径迁移（从根目录迁到源码包下）

若此前 agentcore 在仓库根 `agentcore/`，已改为 `{SOURCE_PACKAGE}/agentcore/` 后，需：

1. 移动目录并修改 `.gitmodules` 中的 `path`。
2. 修正各子模块内 `.git` 文件中的 `gitdir`，使其指向正确的 `/.git/modules/...`（深度随新路径变化）。
3. 执行：

```bash
git submodule sync
git submodule update --init --recursive
```

## entrypoint.sh 与定时任务初始化

引入 agentcore 后，entrypoint 需在合适的时机做两件事（与 easy-divine / devmind 一致）：

1. **注册定时任务（必须）**  
   在 **migrate 之后**、启动 gunicorn / celery-beat 之前执行：
   ```bash
   python manage.py register_periodic_tasks
   ```
   或带容错：`python manage.py register_periodic_tasks || true`。  
   该命令会收集各 app（含 agentcore_task、agentcore_metering、agentcore_notifier）的 `periodic_tasks.register_periodic_tasks()` 并写入 django_celery_beat，Celery Beat 使用 DatabaseScheduler 时才能按表调度。

2. **旧表重命名（可选，一次性升级）**  
   若从自建 llm_tracker / notifier 迁移到 agentcore，且使用 PostgreSQL，在 **migrate 之前**执行：
   ```bash
   python manage.py rename_old_agentcore_tables || true
   ```
   将 `llm_tracker_usage`、`notifier_notification_record` 等表重命名为 `*_old`，避免与 agentcore 的迁移建表冲突。项目需实现该 management command（参考 easy-divine 的 `core/management/commands/rename_old_agentcore_tables.py`）。

**easy-divine 示例**：`run_migrations()` 内先调 `rename_old_tables_if_present()`，再 `migrate`；`run_register_periodic_tasks()` 在 gunicorn 与 celery-beat 分支中于 migrate 之后调用。**devmind 示例**：在 `run_migrations()` 末尾直接执行 `register_periodic_tasks || true`。

## Django 配置要点

- `INSTALLED_APPS` 增加：`agentcore_metering.adapters.django`、`agentcore_task.adapters.django`、`agentcore_notifier.adapters.django`。
- 根 URLconf 增加 agentcore 的 `path(..., include(...))`。
- 业务代码从 `agentcore_task.adapters.django`、`agentcore_metering.adapters.django` 等导入，不再使用自建的 llm_tracker / task_manager / notifier。
- 项目需提供 `core.periodic_registry` 及 management command `register_periodic_tasks`，供各 app（含 agentcore）注册定时任务；Celery 使用 `DatabaseScheduler`，不再依赖静态 `CELERY_BEAT_SCHEDULE`。

## register_periodic_tasks 与 periodic_registry 代码（可直接复用）

本技能在 **`code/`** 目录下提供了可直接复制的实现，其他项目无需从零编写：

| 文件 | 复制到项目中的位置 |
|------|--------------------|
| [code/periodic_registry.py](code/periodic_registry.py) | `{SOURCE_PACKAGE}/core/periodic_registry.py` |
| [code/register_periodic_tasks.py](code/register_periodic_tasks.py) | `{SOURCE_PACKAGE}/core/management/commands/register_periodic_tasks.py` |

说明见 [code/README.md](code/README.md)。若主 app 不叫 `core`，复制后需将代码中的 `from core.periodic_registry import ...` 改为你的 app 名。依赖：Django、django-celery-beat。

本仓库完整说明见：`easy-divine/docs/AGENTCORE_SUBMODULES.md`。
