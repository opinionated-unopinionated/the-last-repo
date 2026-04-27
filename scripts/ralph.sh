#!/usr/bin/env bash
# Ralph Wiggum loop driver for The Last Repo.
# Re-invokes the chosen AI harness against PROMPT.md until <promise>COMPLETE</promise>
# appears in an iteration log, or MAX_ITERS is reached.

set -euo pipefail

HARNESS="${AI_HARNESS:-pi}"
PROMPT_FILE="${PROMPT_FILE:-PROMPT.md}"
MAX_ITERS="${MAX_ITERS:-200}"
LOG_DIR="${LOG_DIR:-.ralph/logs}"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: scripts/ralph.sh [--dry-run] [--help]

Environment:
  AI_HARNESS   pi (default) | claude | codex
  PROMPT_FILE  default: PROMPT.md
  MAX_ITERS    default: 200
  LOG_DIR      default: .ralph/logs

Examples:
  scripts/ralph.sh
  AI_HARNESS=claude scripts/ralph.sh
  scripts/ralph.sh --dry-run
EOF
}

for arg in "$@"; do
  case "$arg" in
    -h|--help)   usage; exit 0 ;;
    --dry-run)   DRY_RUN=1 ;;
    *) echo "unknown arg: $arg" >&2; usage; exit 2 ;;
  esac
done

if [ ! -f "$PROMPT_FILE" ]; then
  echo "prompt file not found: $PROMPT_FILE" >&2
  exit 2
fi

mkdir -p "$LOG_DIR"
LAST_LOG="$LOG_DIR/last.log"

invoke_harness() {
  case "$HARNESS" in
    pi)     pi -p < "$PROMPT_FILE" ;;
    claude) claude -p "$(cat "$PROMPT_FILE")" ;;
    codex)  codex exec - < "$PROMPT_FILE" ;;
    *) echo "unknown AI_HARNESS: $HARNESS (expected: pi|claude|codex)" >&2; exit 2 ;;
  esac
}

if [ "$DRY_RUN" = "1" ]; then
  echo "[dry-run] harness=$HARNESS prompt=$PROMPT_FILE max_iters=$MAX_ITERS log_dir=$LOG_DIR"
  if command -v "$HARNESS" >/dev/null 2>&1; then
    echo "[dry-run] harness CLI '$HARNESS' resolved at: $(command -v "$HARNESS")"
  else
    echo "[dry-run] harness CLI '$HARNESS' NOT installed"
  fi
  exit 0
fi

i=0
while [ "$i" -lt "$MAX_ITERS" ]; do
  i=$((i + 1))
  ts=$(date -u +%Y-%m-%dT%H-%M-%SZ)
  iter_log="$LOG_DIR/${ts}-iter-${i}.log"
  echo "=== ralph iter $i ($ts, harness=$HARNESS) ===" | tee -a "$LAST_LOG"
  if ! invoke_harness 2>&1 | tee "$iter_log" >> "$LAST_LOG"; then
    echo "iter $i: harness exited non-zero; continuing" | tee -a "$LAST_LOG"
  fi
  if grep -q "<promise>COMPLETE</promise>" "$iter_log"; then
    echo "COMPLETE detected on iter $i. exiting." | tee -a "$LAST_LOG"
    exit 0
  fi
done

echo "MAX_ITERS=$MAX_ITERS reached without COMPLETE." | tee -a "$LAST_LOG"
exit 1
