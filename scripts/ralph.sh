#!/usr/bin/env bash
# Ralph Wiggum loop driver for The Last Repo.
# Re-invokes the chosen AI harness against PROMPT.md until the agent creates
# the sentinel file (default .ralph/COMPLETE), or MAX_ITERS is reached.
# A sentinel file is used instead of grepping the transcript so that an agent
# editing a doc that contains the completion tag cannot accidentally end the loop.

set -euo pipefail

HARNESS="${AI_HARNESS:-pi}"
PROMPT_FILE="${PROMPT_FILE:-PROMPT.md}"
MAX_ITERS="${MAX_ITERS:-200}"
LOG_DIR="${LOG_DIR:-.ralph/logs}"
SENTINEL="${SENTINEL:-.ralph/COMPLETE}"
DRY_RUN=0

# Per-harness flags. Defaults are tuned for autonomous Ralph loops (no prompts).
# Override by exporting the relevant *_FLAGS variable.
PI_FLAGS="${PI_FLAGS:-}"
CLAUDE_FLAGS="${CLAUDE_FLAGS:---dangerously-skip-permissions}"
CODEX_FLAGS="${CODEX_FLAGS:-}"

usage() {
  cat <<'EOF'
Usage: scripts/ralph.sh [--dry-run] [--help]

Environment:
  AI_HARNESS    pi (default) | claude | codex
  PROMPT_FILE   default: PROMPT.md
  MAX_ITERS     default: 200
  LOG_DIR       default: .ralph/logs
  SENTINEL      completion sentinel file (default: .ralph/COMPLETE)
  PI_FLAGS      extra flags passed to `pi`     (default: empty)
  CLAUDE_FLAGS  extra flags passed to `claude` (default: --dangerously-skip-permissions)
  CODEX_FLAGS   extra flags passed to `codex`  (default: empty)

Examples:
  scripts/ralph.sh
  AI_HARNESS=claude scripts/ralph.sh
  AI_HARNESS=claude CLAUDE_FLAGS="" scripts/ralph.sh   # require approvals
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
mkdir -p "$(dirname "$SENTINEL")"
LAST_LOG="$LOG_DIR/last.log"

# Clear any stale sentinel from a prior run so we only react to a fresh signal.
rm -f "$SENTINEL"

invoke_harness() {
  # Word-splitting on *_FLAGS is intentional so multiple flags work.
  # shellcheck disable=SC2086
  case "$HARNESS" in
    pi)     pi $PI_FLAGS -p < "$PROMPT_FILE" ;;
    claude) claude $CLAUDE_FLAGS -p "$(cat "$PROMPT_FILE")" ;;
    codex)  codex $CODEX_FLAGS exec - < "$PROMPT_FILE" ;;
    *) echo "unknown AI_HARNESS: $HARNESS (expected: pi|claude|codex)" >&2; exit 2 ;;
  esac
}

if [ "$DRY_RUN" = "1" ]; then
  echo "[dry-run] harness=$HARNESS prompt=$PROMPT_FILE max_iters=$MAX_ITERS log_dir=$LOG_DIR sentinel=$SENTINEL"
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
  # Remove any sentinel from the previous iteration before invoking the harness,
  # so we only detect a signal that this iteration just produced.
  rm -f "$SENTINEL"
  if ! invoke_harness 2>&1 | tee "$iter_log" >> "$LAST_LOG"; then
    echo "iter $i: harness exited non-zero; continuing" | tee -a "$LAST_LOG"
  fi
  if [ -f "$SENTINEL" ]; then
    echo "COMPLETE sentinel ($SENTINEL) detected on iter $i. exiting." | tee -a "$LAST_LOG"
    rm -f "$SENTINEL"
    exit 0
  fi
done

echo "MAX_ITERS=$MAX_ITERS reached without COMPLETE sentinel ($SENTINEL)." | tee -a "$LAST_LOG"
exit 1
