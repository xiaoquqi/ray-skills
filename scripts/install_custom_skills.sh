#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LIST_FILE="$ROOT_DIR/scripts/custom-skills.txt"
TEMP_DIR="$ROOT_DIR/.tmp/custom-skills"
DRY_RUN=0
FORCE=0

TARGETS=(
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.windsurf/skills"
)

ENTRIES=()

usage() {
  cat <<USAGE
Install custom skills from GitHub repositories.

Usage:
  $(basename "$0") [options]

Options:
  --list-file <path>   Skill list file (default: scripts/custom-skills.txt)
  --dry-run            Print actions without executing
  --force              Replace existing destination entries
  -h, --help           Show this help

Examples:
  ./scripts/install_custom_skills.sh
  ./scripts/install_custom_skills.sh --dry-run
  ./scripts/install_custom_skills.sh --force
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

normalize_repo_url() {
  local source="$1"

  source="${source#https://github.com/}"
  source="${source#http://github.com/}"
  source="${source#github.com/}"
  source="${source#git@github.com:}"
  source="${source%.git}"
  source="${source%%\?*}"
  source="${source%%\#*}"

  case "$source" in
    */tree/*)
      source="${source%%/tree/*}"
      ;;
    */blob/*)
      source="${source%%/blob/*}"
      ;;
  esac

  source="${source%%/}"
  printf '%s\n' "github.com/$source"
}

repo_name() {
  local repo_url="$1"
  printf '%s' "$repo_url" | sed -E 's|.*github\.com/([^/]+/[^/]+).*|\1|'
}

clone_url() {
  local repo_url="$1"
  local normalized
  normalized="$(normalize_repo_url "$repo_url")"
  printf '%s\n' "https://github.com/${normalized#github.com/}.git"
}

skill_name_from_path() {
  local repo_name_value="$1"
  local target_path="$2"

  if [[ "$target_path" == "." ]] || [[ -z "$target_path" ]]; then
    printf '%s\n' "${repo_name_value##*/}"
    return 0
  fi

  printf '%s\n' "$(basename "$target_path")"
}

parse_entry() {
  local line="$1"

  line="${line%%#*}"
  line="$(printf '%s' "$line" | xargs || true)"
  [[ -z "$line" ]] && return 1

  local repo_url=""
  local target_path=""

  if [[ "$line" == *" -> "* ]]; then
    repo_url="${line%% -> *}"
    target_path="${line#* -> }"
  else
    repo_url="$line"
    target_path="all"
  fi

  repo_url="$(normalize_repo_url "$repo_url")"

  if [[ -z "$target_path" ]] && [[ "$repo_url" == *"/tree/"* ]]; then
    target_path="${repo_url#*/tree/}"
    target_path="${target_path#*/}"
  fi

  if [[ -z "$repo_url" ]] || [[ -z "$target_path" ]]; then
    log "invalid entry format: $line"
    return 1
  fi

  printf '%s|%s\n' "$repo_url" "$target_path"
}

load_list_file() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    log "list file not found: $path"
    exit 1
  fi

  while IFS= read -r line; do
    if entry=$(parse_entry "$line"); then
      ENTRIES+=("$entry")
    fi
  done < "$path"
}

copy_skill() {
  local src="$1"
  local dest="$2"
  local skill_name
  skill_name="$(basename "$dest")"

  if [[ ! -d "$src" ]]; then
    log "source not found: $src"
    return 1
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      run_cmd "rm -rf \"$dest\""
    else
      log "skip existing path: $dest (use --force to replace)"
      return 0
    fi
  fi

  run_cmd "mkdir -p \"$(dirname "$dest")\""
  run_cmd "cp -R \"$src\" \"$dest\""
  log "installed: $skill_name -> $dest"
}

install_repo() {
  local repo_url="$1"
  local target_path="$2"
  local repo
  repo="$(repo_name "$repo_url")"
  local git_url
  git_url="$(clone_url "$repo_url")"
  local clone_dir="$TEMP_DIR/$repo"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] git clone --depth 1 \"$git_url\" \"$clone_dir\""
  fi

  if [[ "$DRY_RUN" -eq 0 ]]; then
    if [[ ! -d "$clone_dir" ]]; then
      run_cmd "mkdir -p \"$TEMP_DIR\""
      run_cmd "git clone --depth 1 \"$git_url\" \"$clone_dir\""
    fi
  fi

  if [[ "$target_path" == "all" ]]; then
    while IFS= read -r -d '' skill_file; do
      local skill_dir
      skill_dir="$(dirname "$skill_file")"
      local skill_name
      skill_name="$(basename "$skill_dir")"
      for target in "${TARGETS[@]}"; do
        copy_skill "$skill_dir" "$target/$skill_name"
      done
    done < <(find "$clone_dir" -name "SKILL.md" -print0 2>/dev/null)
    return 0
  fi

  local src="$clone_dir/$target_path"
  local skill_name
  skill_name="$(skill_name_from_path "$repo" "$target_path")"

  if [[ "$target_path" == "." ]]; then
    src="$clone_dir"
  fi

  for target in "${TARGETS[@]}"; do
    copy_skill "$src" "$target/$skill_name"
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list-file)
      LIST_FILE="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --force)
      FORCE=1
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

load_list_file "$LIST_FILE"

if [[ "${#ENTRIES[@]}" -eq 0 ]]; then
  log "no entries resolved"
  exit 1
fi

header "Installing custom skills"
for entry in "${ENTRIES[@]}"; do
  repo_url="${entry%%|*}"
  target_path="${entry##*|}"
  header "Processing: $repo_url"
  install_repo "$repo_url" "$target_path"
done

log ""
log "All done. Restart your IDE (Codex, Claude Code, Cursor, etc.) to pick up new skills."
