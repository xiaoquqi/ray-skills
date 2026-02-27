# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal skill collection for agent-based coding workflows. Skills are self-contained modules that provide specialized knowledge and workflows for AI coding agents.

## Commands

### Install Skills (Symlink Mode - Recommended)

Install local skills to agent directories. Symlink mode keeps global skills in sync with this repo.

```bash
# Install to all known targets
./scripts/install_skills.sh --all-targets

# Install to specific target
./scripts/install_skills.sh --target ~/.codex/skills

# Dry run to preview actions
./scripts/install_skills.sh --all-targets --dry-run

# Use copy mode instead of symlink
./scripts/install_skills.sh --mode copy --target ~/.codex/skills
```

### Uninstall Skills

```bash
# Remove from all targets
./scripts/install_skills.sh --all-targets --uninstall
```

### Install Common Marketplace Skills

Install curated skills from `scripts/common-skills.txt` via Smithery CLI:

```bash
# Dry run first
./scripts/install_common_skills.sh --dry-run

# Real install
./scripts/install_common_skills.sh

# Install specific skills only
./scripts/install_common_skills.sh --skill anthropics/pdf --skill github/refactor
```

### Health Check

Verify global skill links point to this repository:

```bash
./scripts/doctor.sh --all-targets
```

### Development Validation

Quick checks when modifying skills:

```bash
# List all repository files
rg --files

# Verify skill files exist
find skills -maxdepth 2 -type f

# Check heading structure in skill docs
rg "^#" skills/*/SKILL.md
```

## Architecture

### Skill Structure

Skills are auto-discovered from subdirectories under `skills/` that contain a `SKILL.md` file. Each skill is self-contained with its own documentation and rules.

```
skills/
├── ray-git-commit/     # Staged-diff commit message + auto-commit workflow
├── ray-review-python/  # Python review/style standards
├── python-code-review/ # Local copy of baseline rules
└── python-expert/      # Local copy of baseline rules
```

### Installation Targets

Known agent skill directories:
- `~/.codex/skills`
- `~/.agents/skills`
- `~/.claude/skills`
- `~/.cursor/skills`
- `~/.windsurf/skills`

### Always-Replace Skills

The following skills are always replaced during install (defined in `install_skills.sh`):
- `python-expert`
- `python-code-review`

## Conventions

- Directory names: kebab-case (e.g., `my-new-skill/`)
- Required file: `SKILL.md` (uppercase, exact)
- Documentation and code comments: English only
- Commit format: `type(scope): imperative summary` (e.g., `docs(skill): clarify staged-diff constraint`)
