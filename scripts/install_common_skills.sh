#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LIST_FILE="$ROOT_DIR/scripts/common-skills.txt"
DRY_RUN=0
CONTINUE_ON_ERROR=0
AGENTS=("codex" "claude-code" "cursor" "gemini-cli" "opencode")
SYNC_ALL_TARGETS=1
SYNC_ONLY=0
FORCE_SYNC=0

KNOWN_TARGETS=(
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.windsurf/skills"
)

SKILLS=()

usage() {
  cat <<USAGE
Install common marketplace skills one by one.

By default this script uses:
  npx @smithery/cli@latest skill add <owner/skill> --agent <a,b,c> --global

Usage:
  $(basename "$0") [options]

Options:
  --list-file <path>      Skill list file (default: scripts/common-skills.txt)
  --skill <owner/name>    Add a single skill (repeatable)
  --only-listed           Ignore --skill values and use list file only
  --sync-only             Skip install and only sync to IDE skill directories
  --no-sync               Disable syncing to IDE skill directories
  --force-sync            Replace existing non-symlink entries during sync
  --dry-run               Print actions without executing
  --continue-on-error     Continue when one skill install fails
  --agents <a,b,c>        Agents passed to skill add (default: codex,claude-code,cursor,gemini-cli,opencode)
  --print-list            Print resolved skill list and exit
  -h, --help              Show this help

Examples:
  ./scripts/install_common_skills.sh
  ./scripts/install_common_skills.sh --sync-only
  ./scripts/install_common_skills.sh --dry-run
  ./scripts/install_common_skills.sh --skill anthropics/pdf --skill github/refactor
USAGE
}

log() {
  printf '%s\n' "$*"
}

header() {
  printf '\n==> %s\n\n' "$*"
}

run_cmd() {
  local cmd="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] $cmd"
    return 0
  fi

  eval "$cmd"
}

load_list_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    log "list file not found: $path"
    exit 1
  fi

  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(printf '%s' "$line" | xargs || true)"
    [[ -z "$line" ]] && continue
    SKILLS+=("$line")
  done < "$path"
}

unique_skills() {
  local seen=""
  local out=()
  local s
  for s in "${SKILLS[@]}"; do
    if [[ ",$seen," == *",$s,"* ]]; then
      continue
    fi
    out+=("$s")
    seen+="${seen:+,}$s"
  done

  SKILLS=("${out[@]}")
}

normalize_slug() {
  local slug="$1"
  case "$slug" in
    antfu/skills)
      printf '%s\n' "antfu/antfu"
      ;;
    *)
      printf '%s\n' "$slug"
      ;;
  esac
}

skill_dir_name() {
  local slug
  slug="$(normalize_slug "$1")"
  # Extract only the skill name part (after the last slash)
  printf '%s\n' "${slug##*/}"
}

safe_remove_dest() {
  local dest="$1"

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    return 0
  fi

  if [[ -L "$dest" ]]; then
    run_cmd "rm -f \"$dest\""
    return 0
  fi

  if [[ "$FORCE_SYNC" -eq 1 ]]; then
    run_cmd "rm -rf \"$dest\""
    return 0
  fi

  log "skip existing non-symlink path: $dest (use --force-sync to replace)"
  return 1
}

sync_skill_to_targets() {
  local slug="$1"
  local name
  name="$(skill_dir_name "$slug")"
  local src="$HOME/.agents/skills/$name"
  local target=""
  local dest=""

  # Skip if source doesn't exist
  if [[ ! -d "$src" ]]; then
    return 0
  fi

  if [[ ! -d "$src" ]]; then
    log "skip sync missing source: $src"
    return 0
  fi

  for target in "${KNOWN_TARGETS[@]}"; do
    if [[ "$target" == "$HOME/.agents/skills" ]]; then
      continue
    fi

    run_cmd "mkdir -p \"$target\""
    dest="$target/$name"
    safe_remove_dest "$dest" || continue
    run_cmd "ln -s \"$src\" \"$dest\""
    log "synced: $name -> $dest"
  done
}

sync_all_skills() {
  local slug=""
  for slug in "${SKILLS[@]}"; do
    sync_skill_to_targets "$slug"
  done
}

install_one() {
  local slug
  slug="$(normalize_slug "$1")"
  local agent_flags=""
  local agent=""

  if ! command -v npx >/dev/null 2>&1; then
    log "missing installer for $slug (need npx)"
    return 127
  fi

  for agent in "${AGENTS[@]}"; do
    agent_flags+=" --agent \"$agent\""
  done

  log "installing: $slug"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] npx --yes @smithery/cli@latest skill add \"$slug\"$agent_flags --global"
    return 0
  fi

  # Suppress output unless there's an error
  if ! npx --yes @smithery/cli@latest skill add "$slug"$agent_flags --global >/dev/null 2>&1; then
    log "failed: $slug"
    return 1
  fi

  log "  ✓ installed: $slug"
  return 0
}

USE_LIST_FILE=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --list-file)
      LIST_FILE="${2:-}"
      shift 2
      ;;
    --skill)
      SKILLS+=("${2:-}")
      USE_LIST_FILE=0
      shift 2
      ;;
    --only-listed)
      USE_LIST_FILE=1
      shift
      ;;
    --sync-only)
      SYNC_ONLY=1
      shift
      ;;
    --no-sync)
      SYNC_ALL_TARGETS=0
      shift
      ;;
    --force-sync)
      FORCE_SYNC=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --continue-on-error)
      CONTINUE_ON_ERROR=1
      shift
      ;;
    --agents)
      IFS=',' read -r -a AGENTS <<< "${2:-}"
      shift 2
      ;;
    --print-list)
      PRINT_LIST=1
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

if [[ "$USE_LIST_FILE" -eq 1 ]]; then
  load_list_file "$LIST_FILE"
fi

if [[ "${#SKILLS[@]}" -eq 0 ]]; then
  log "no skills resolved"
  exit 1
fi

if [[ "${#AGENTS[@]}" -eq 0 || -z "${AGENTS[0]}" ]]; then
  log "no agents resolved (use --agents codex,claude-code,cursor,gemini-cli,opencode)"
  exit 1
fi

unique_skills

if [[ "${PRINT_LIST:-0}" -eq 1 ]]; then
  printf '%s\n' "${SKILLS[@]}"
  exit 0
fi

header "Installing skills"
fail_count=0
if [[ "$SYNC_ONLY" -eq 0 ]]; then
  for slug in "${SKILLS[@]}"; do
    if ! install_one "$slug"; then
      log "failed: $slug"
      fail_count=$((fail_count + 1))
      if [[ "$CONTINUE_ON_ERROR" -eq 0 ]]; then
        exit 2
      fi
    fi
  done
  header "Installation complete"
fi

if [[ "$fail_count" -gt 0 ]]; then
  log "completed with failures: $fail_count"
  exit 2
fi

if [[ "$SYNC_ALL_TARGETS" -eq 1 ]]; then
  header "Syncing to IDE directories"
  sync_all_skills
  header "Sync complete"
fi

log ""
log "All done. Restart your IDE (Codex, Claude Code, Cursor, etc.) to pick up new skills."
