# ray-skills

Personal skill collection for agent-based coding workflows.

## Structure

- `skills/ray-git-commit/`: staged-diff commit message + auto-commit workflow
- `skills/ray-review-python/`: Python review/style standards
- `skills/python-code-review/`: local copy of python-code-review baseline rules
- `skills/python-expert/`: local copy of python-expert baseline rules
- `skills/`: skill modules root directory
- `scripts/install_skills.sh`: global installer (symlink-first)

## Install Globally (Recommended: Symlink)

Symlink mode keeps your global skills always in sync with this repo.

```bash
# Install to Codex default target (~/.codex/skills)
./scripts/install_skills.sh

# Install to multiple common targets
./scripts/install_skills.sh --all-targets

# Install to specific targets
./scripts/install_skills.sh \
  --target ~/.codex/skills \
  --target ~/.agents/skills
```

## Uninstall

```bash
# Remove linked/copied skill entries from known targets
./scripts/install_skills.sh --all-targets --uninstall

# Remove from one target only
./scripts/install_skills.sh --target ~/.codex/skills --uninstall
```

## Useful Options

```bash
# Preview actions without writing
./scripts/install_skills.sh --all-targets --dry-run

# Use copy mode instead of symlink
./scripts/install_skills.sh --mode copy --target ~/.codex/skills

# Replace existing target entries
./scripts/install_skills.sh --all-targets --force
```

## Install Common Marketplace Skills

Install a curated common set (from `scripts/common-skills.txt`) one by one:

```bash
# Dry run
./scripts/install_common_skills.sh --dry-run

# Real install
./scripts/install_common_skills.sh
```

Optional usage:

```bash
# Install only selected skills
./scripts/install_common_skills.sh --skill anthropics/pdf --skill github/refactor

# Continue even if one install fails
./scripts/install_common_skills.sh --continue-on-error

# Install for specific agents only
./scripts/install_common_skills.sh --agents codex,claude-code,cursor,gemini-cli,opencode
```

For `antfu/skills`, you can also install specific sub-skills (for example Vue and
Vitest) with:

```bash
npx skills add https://github.com/antfu/skills --skill vue --skill vitest
```

## Health Check

Verify whether global skill links point to this repository:

```bash
./scripts/doctor.sh --all-targets
```

## Notes

- Skill directories are auto-discovered from:
  - subfolders under `skills/` containing `SKILL.md`
- If a destination already exists and is not a symlink, installer skips it unless `--force` is set.
- Documentation and code comments in this repository must be in English only.
