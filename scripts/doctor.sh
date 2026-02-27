#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

TARGETS=()
FAIL_ON_WARN=0

KNOWN_TARGETS=(
  "$HOME/.codex/skills"
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.windsurf/skills"
)

usage() {
  cat <<USAGE
Check whether global skill entries are linked correctly to this repository.

Usage:
  $(basename "$0") [options]

Options:
  --target <path>   Check one target path (repeatable)
  --all-targets     Check known default targets
  --fail-on-warn    Exit non-zero when warnings are found
  -h, --help        Show this help

Examples:
  ./scripts/doctor.sh --all-targets
  ./scripts/doctor.sh --target ~/.codex/skills --fail-on-warn
USAGE
}

log() {
  printf '%s\n' "$*"
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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGETS+=("${2:-}")
      shift 2
      ;;
    --all-targets)
      TARGETS+=("${KNOWN_TARGETS[@]}")
      shift
      ;;
    --fail-on-warn)
      FAIL_ON_WARN=1
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

if [[ "${#TARGETS[@]}" -eq 0 ]]; then
  TARGETS+=("$HOME/.codex/skills")
fi

mapfile -t SKILLS < <(collect_skills)
if [[ "${#SKILLS[@]}" -eq 0 ]]; then
  log "no skill directories found (need folders with SKILL.md)"
  exit 1
fi

ok_count=0
warn_count=0

log "root: $ROOT_DIR"
log "skills found: ${#SKILLS[@]}"

for target in "${TARGETS[@]}"; do
  log "target: $target"

  if [[ ! -d "$target" ]]; then
    log "  WARN target does not exist"
    warn_count=$((warn_count + 1))
    continue
  fi

  for src in "${SKILLS[@]}"; do
    name="$(basename "$src")"
    dest="$target/$name"

    if [[ ! -e "$dest" && ! -L "$dest" ]]; then
      log "  WARN missing: $dest"
      warn_count=$((warn_count + 1))
      continue
    fi

    if [[ -L "$dest" ]]; then
      linked_to="$(readlink "$dest")"
      if [[ "$linked_to" == "$src" ]]; then
        log "  OK symlink: $name"
        ok_count=$((ok_count + 1))
      else
        log "  WARN wrong symlink: $name -> $linked_to (expected $src)"
        warn_count=$((warn_count + 1))
      fi
      continue
    fi

    log "  WARN not a symlink: $dest"
    warn_count=$((warn_count + 1))
  done
done

log "summary: ok=$ok_count warn=$warn_count"

if [[ "$FAIL_ON_WARN" -eq 1 && "$warn_count" -gt 0 ]]; then
  exit 2
fi
