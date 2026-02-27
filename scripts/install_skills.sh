#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MODE="symlink"
DRY_RUN=0
FORCE=0
UNINSTALL=0

TARGETS=()

KNOWN_TARGETS=(
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.windsurf/skills"
)

ALWAYS_REPLACE_SKILLS=(
  "python-expert"
  "python-code-review"
)

usage() {
  cat <<USAGE
Install or uninstall skills from this repository into global skill folders.

Usage:
  $(basename "$0") [options]

Options:
  --mode symlink|copy   Install mode (default: symlink)
  --target <path>       Add an install target (repeatable)
  --all-targets         Install to known default targets
  --force               Replace existing destination entry
  --dry-run             Print actions without changing files
  --uninstall           Remove installed entries from targets
  -h, --help            Show this help

Examples:
  ./scripts/install_skills.sh
  ./scripts/install_skills.sh --target ~/.codex/skills --target ~/.agents/skills
  ./scripts/install_skills.sh --all-targets --uninstall
USAGE
}

log() {
  printf '%s\n' "$*"
}

status_word() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '%s' "would"
  else
    printf '%s' "done"
  fi
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] $*"
  else
    eval "$@"
  fi
}

collect_skills() {
  local skills=()
  local d

  while IFS= read -r d; do
    skills+=("$d")
  done < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -name 'ray-*' -print | sort)

  if [[ -d "$ROOT_DIR/skills" ]]; then
    while IFS= read -r d; do
      skills+=("$d")
    done < <(find "$ROOT_DIR/skills" -mindepth 1 -maxdepth 1 -type d -print | sort)
  fi

  local filtered=()
  for d in "${skills[@]}"; do
    if [[ -f "$d/SKILL.md" ]]; then
      filtered+=("$d")
    fi
  done

  printf '%s\n' "${filtered[@]}"
}

safe_remove_existing() {
  local dest="$1"

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    return 0
  fi

  if [[ "$FORCE" -eq 1 ]]; then
    run "rm -rf \"$dest\""
    return 0
  fi

  if [[ -L "$dest" ]]; then
    run "rm -f \"$dest\""
    return 0
  fi

  log "skip existing non-symlink path: $dest (use --force to replace)"
  return 1
}

install_one() {
  local src="$1"
  local target_root="$2"
  local name
  name="$(basename "$src")"
  local dest="$target_root/$name"
  local force_replace=0
  local n
  for n in "${ALWAYS_REPLACE_SKILLS[@]}"; do
    if [[ "$name" == "$n" ]]; then
      force_replace=1
      break
    fi
  done

  run "mkdir -p \"$target_root\""

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$force_replace" -eq 1 ]]; then
      run "rm -rf \"$dest\""
    else
      safe_remove_existing "$dest" || return 0
    fi
  fi

  if [[ "$MODE" == "copy" ]]; then
    run "cp -R \"$src\" \"$dest\""
    log "$(status_word) install (copy): $name -> $dest"
  else
    run "ln -s \"$src\" \"$dest\""
    log "$(status_word) install (symlink): $name -> $dest"
  fi
}

uninstall_one() {
  local src="$1"
  local target_root="$2"
  local name
  name="$(basename "$src")"
  local dest="$target_root/$name"

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    log "skip missing: $dest"
    return 0
  fi

  if [[ -L "$dest" ]]; then
    run "rm -f \"$dest\""
    log "$(status_word) remove symlink: $dest"
    return 0
  fi

  if [[ "$FORCE" -eq 1 ]]; then
    run "rm -rf \"$dest\""
    log "$(status_word) remove path (--force): $dest"
    return 0
  fi

  log "skip non-symlink path: $dest (use --force with --uninstall to remove)"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --target)
      TARGETS+=("${2:-}")
      shift 2
      ;;
    --all-targets)
      TARGETS+=("${KNOWN_TARGETS[@]}")
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --uninstall)
      UNINSTALL=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ "$MODE" != "symlink" && "$MODE" != "copy" ]]; then
  log "invalid --mode: $MODE"
  exit 1
fi

if [[ "${#TARGETS[@]}" -eq 0 ]]; then
  TARGETS=("${KNOWN_TARGETS[@]}")
fi

mapfile -t SKILLS < <(collect_skills)

if [[ "${#SKILLS[@]}" -eq 0 ]]; then
  log "no skill directories found (need folders with SKILL.md)"
  exit 1
fi

log "root: $ROOT_DIR"
log "skills found: ${#SKILLS[@]}"

for target in "${TARGETS[@]}"; do
  log "target: $target"
  for src in "${SKILLS[@]}"; do
    if [[ "$UNINSTALL" -eq 1 ]]; then
      uninstall_one "$src" "$target"
    else
      install_one "$src" "$target"
    fi
  done
done

log "done"
