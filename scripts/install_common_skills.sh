#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LIST_FILE="$ROOT_DIR/scripts/common-skills.txt"
DRY_RUN=0
CONTINUE_ON_ERROR=0
AGENTS=("codex" "claude-code" "cursor" "gemini-cli" "opencode")

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
  --dry-run               Print actions without executing
  --continue-on-error     Continue when one skill install fails
  --agents <a,b,c>        Agents passed to skill add (default: codex,claude-code,cursor,gemini-cli,opencode)
  --print-list            Print resolved skill list and exit
  -h, --help              Show this help

Examples:
  ./scripts/install_common_skills.sh
  ./scripts/install_common_skills.sh --dry-run
  ./scripts/install_common_skills.sh --skill anthropics/pdf --skill github/refactor
USAGE
}

log() {
  printf '%s\n' "$*"
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

  log "installing: $slug (via npx skill add, agents=${AGENTS[*]}, global)"
  run_cmd "npx @smithery/cli@latest skill add \"$slug\"$agent_flags --global"
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

fail_count=0
for slug in "${SKILLS[@]}"; do
  if ! install_one "$slug"; then
    log "failed: $slug"
    fail_count=$((fail_count + 1))
    if [[ "$CONTINUE_ON_ERROR" -eq 0 ]]; then
      exit 2
    fi
  fi
done

if [[ "$fail_count" -gt 0 ]]; then
  log "completed with failures: $fail_count"
  exit 2
fi

log "completed successfully"
log "Restart Codex to pick up new skills."
