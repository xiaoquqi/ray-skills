# Repository Guidelines

## Project Structure & Module Organization
This repository is organized as skill modules under `skills/`. Each skill is self-contained.

- `skills/ray-git-commit/SKILL.md`: workflow and constraints for generating commit logs from staged diffs.
- `skills/ray-review-python/SKILL.md`: Python code-style and review standards.

Keep new skills in `skills/<skill-name>/` (kebab-case), with `SKILL.md` at the folder root.

## Build, Test, and Development Commands
There is no build system in this repo; development is documentation-first.

- `rg --files`: list repository files quickly.
- `find skills -maxdepth 2 -type f`: verify expected skill files exist.
- `rg "^#" skills/*/SKILL.md`: check heading structure in skill docs.

If you add automation, document runnable commands in this file and keep them non-interactive.

## Coding Style & Naming Conventions
Use clear, concise Markdown with actionable instructions.

- Directory names: kebab-case (example: `my-new-skill/`).
- Required file name: `SKILL.md` (uppercase, exact).
- Documentation and code comments must be written in English only.
- Keep sections short, imperative, and operational.
- Prefer concrete command examples (for example: `git -C <repo_dir> diff --cached`).

For Python guidance referenced by skills, follow `skills/ray-review-python/SKILL.md`.

## Testing Guidelines
Test changes by validating instructions are executable and consistent.

- Ensure every command in a skill doc is copy/paste runnable.
- Confirm referenced paths exist.
- Re-run quick checks after edits: `rg --files`, `rg "TODO|FIXME" skills/*/SKILL.md`.

For future scripted tests, place them under a top-level `tests/` directory and name files `test_<feature>.py`.

## Commit & Pull Request Guidelines
Git metadata is not present in this workspace snapshot, so historical commit conventions cannot be inferred directly.

Use this standard going forward:

- Commit format: `type(scope): imperative summary` (example: `docs(skill): clarify staged-diff constraint`).
- Keep commits focused to one skill or concern.
- PRs should include: purpose, changed paths, validation commands run, and before/after snippets for behavioral docs updates.
