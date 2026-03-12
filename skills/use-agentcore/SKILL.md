---
name: use-agentcore
description: >-
  Guides correct integration of agentcore (agentcore-task, agentcore-metering,
  agentcore-notifier) into Django projects. Use when adding agentcore, migrating
  to agentcore, aligning with easy-divine/devmind agentcore layout, or when the
  user asks how to introduce or integrate agentcore modules in a project.
---

# 使用 Agentcore（引入与集成）

本技能确保 agentcore 的引入方式与 easy-divine / devmind 一致，满足三点：**agentcore 位于源码路径下**、**研发模式默认使用本地目录安装**、**Docker 研发与生产构建区分**。

## 三条必须满足的规则

| 规则 | 说明 |
|-----|------|
| **1. 路径** | agentcore 必须在**项目源码包目录内**（即被 Docker `COPY` 进镜像的那一层），不能放在仓库根下与源码包平级。 |
| **2. 研发安装** | 研发模式下默认用本地 agentcore 目录做 `pip install -e`，便于改 agentcore 即生效、无需先发 GitHub。 |
| **3. Dev vs Prod** | docker-compose **研发** 使用 `DEV_MODE=1` 并挂载源码；**生产** 使用 `DEV_MODE=0`，不挂载源码。 |

## 快速检查清单

引入或审查 agentcore 时，按下列项逐条核对：

- [ ] **子模块路径**：agentcore 在 `{SOURCE_PACKAGE}/agentcore/` 下（例如 easy-divine 为 `easy_divine/agentcore/`，devmind 为 `devmind/agentcore/`），即物理路径为 `repo/{SOURCE_PACKAGE}/agentcore/agentcore-*`。
- [ ] **.gitmodules**：`path` 为 `{SOURCE_PACKAGE}/agentcore/agentcore-metering` 等，不是仓库根的 `agentcore/...`。
- [ ] **Dockerfile**：`COPY {SOURCE_PACKAGE} /opt/...` 会包含 agentcore；存在 `ARG DEV_MODE=0` 且在 `DEV_MODE=1` 时对 `.../agentcore/*/` 执行 `pip install -e .`。
- [ ] **docker-compose.dev.yml**：build args 含 `DEV_MODE: "1"`，并挂载 `./{SOURCE_PACKAGE}:/opt/...`。
- [ ] **docker-compose.yml（生产）**：build args 含 `DEV_MODE: "0"`，不挂载源码卷。
- [ ] **pyproject.toml**：依赖中保留从 GitHub 安装的 agentcore（生产与 CI 使用）。
- [ ] **entrypoint.sh**：在 migrate 之后执行 `register_periodic_tasks`，使 agentcore 与业务 app 的定时任务写入 django_celery_beat；若从自建 llm_tracker/notifier 迁移，在 migrate 前执行 `rename_old_agentcore_tables`（可选）。

## 实施步骤（新项目或新引入时）

### 1. 子模块放在源码包下

将 agentcore 放在**会被 COPY 进镜像的目录**内。若镜像里工作目录是 `/opt/my_project`，则 COPY 的是仓库里的 `my_project/` 目录，agentcore 必须在 `my_project/agentcore/` 下。

```bash
# 在仓库根执行，{SOURCE_PACKAGE} 替换为你的 Django 源码包名（如 easy_divine、devmind）
mkdir -p {SOURCE_PACKAGE}/agentcore
git submodule add https://github.com/cloud2ai/agentcore-metering.git {SOURCE_PACKAGE}/agentcore/agentcore-metering
git submodule add https://github.com/cloud2ai/agentcore-task.git {SOURCE_PACKAGE}/agentcore/agentcore-task
git submodule add https://github.com/cloud2ai/agentcore-notifier.git {SOURCE_PACKAGE}/agentcore/agentcore-notifier
```

### 2. Dockerfile：DEV_MODE + 可编辑安装

- 在 COPY 项目文件之后、安装完主依赖之后，增加：
  - `ARG DEV_MODE=0`
  - 当 `DEV_MODE=1` 时，对镜像内 `.../agentcore/*/` 中每个含 `pyproject.toml` 的子目录执行 `pip install -e .`（或 `uv pip install --system -e .`）。

参考片段（路径按项目替换）：

```dockerfile
ARG DEV_MODE=0
RUN set -eux; \
    if [ "$DEV_MODE" = "1" ]; then \
        for d in /opt/{SOURCE_PACKAGE}/agentcore/*/; do \
            if [ -f "${d}pyproject.toml" ]; then \
                (cd "$d" && pip install -e .); \
            fi; \
        done; \
    fi
```

### 3. docker-compose 区分研发与生产

- **研发**（如 `docker-compose.dev.yml`）：build args 传 `DEV_MODE: "1"`；挂载 `./{SOURCE_PACKAGE}:/opt/...`，使容器内使用宿主机 agentcore。
- **生产**（如 `docker-compose.yml`）：build args 传 `DEV_MODE: "0"`；不挂载源码，仅用镜像内由 GitHub 依赖安装的 agentcore。

### 4. entrypoint.sh：定时任务初始化

agentcore 与业务 app 的**定时任务**需在启动时写入 django_celery_beat，Celery Beat 才会按表调度。

- **在 migrate 之后**执行：`python manage.py register_periodic_tasks`（或 `|| true` 避免失败阻断启动）。  
  该命令会遍历 `INSTALLED_APPS` 中各 app 的 `periodic_tasks.register_periodic_tasks()`（含 agentcore_task、agentcore_metering、agentcore_notifier），将 cron 写入 django_celery_beat（幂等）。
- **调用时机**：在 **gunicorn** 与 **celery-beat** 分支中，在 `run_migrations` 之后、启动进程之前调用一次；devmind 则在 `run_migrations` 末尾直接执行该命令。
- **若从自建 llm_tracker/notifier 迁移**：在 migrate 之前执行 `python manage.py rename_old_agentcore_tables || true`，将旧表重命名为 `*_old`，避免与 agentcore 迁移冲突（仅 PostgreSQL，一次性升级）。详见 [reference.md](reference.md) 的 entrypoint 小节。

**实现代码**：`register_periodic_tasks` 与 `periodic_registry` 的完整可复用代码已放在本技能的 **[code/](code/)** 目录，其他项目可直接复制到自己的 core app 下使用，见 [reference.md](reference.md) 的「register_periodic_tasks 与 periodic_registry 代码」小节。

## 参考实现

- 本仓库：`easy-divine/docs/AGENTCORE_SUBMODULES.md`、`easy-divine/Dockerfile`、`docker-compose.dev.yml` / `docker-compose.yml`。
- devmind：agentcore 在 `devmind/agentcore/`，Dockerfile 与 compose 使用相同 DEV_MODE 与挂载模式。

更多细节与迁移说明见 [reference.md](reference.md)。
