#!/usr/bin/env bash
# AI harness dispatch wrapper for The Last Repo.
# Runs a single, non-looping invocation of the chosen harness (pi|claude|codex)
# against a prompt file. The Ralph loop driver (scripts/ralph.sh) embeds the
# same dispatch logic; this script exposes it standalone so callers, generators,
# and one-shot debugging can reuse the harness selection contract.

set -euo pipefail

HARNESS="${AI_HARNESS:-pi}"
PROMPT_FILE="${PROMPT_FILE:-PROMPT.md}"
DRY_RUN=0

PI_FLAGS="${PI_FLAGS:-}"
CLAUDE_FLAGS="${CLAUDE_FLAGS:---dangerously-skip-permissions}"
CODEX_FLAGS="${CODEX_FLAGS:-}"

usage() {
  cat <<'EOF'
Usage: scripts/harness.sh [--dry-run] [--help] [PROMPT_FILE]

Dispatch a single invocation of the chosen AI harness against a prompt file.

Arguments:
  PROMPT_FILE   path to prompt (default: $PROMPT_FILE or PROMPT.md)

Environment:
  AI_HARNESS    pi (default) | claude | codex
  PROMPT_FILE   default: PROMPT.md
  PI_FLAGS      extra flags passed to `pi`     (default: empty)
  CLAUDE_FLAGS  extra flags passed to `claude` (default: --dangerously-skip-permissions)
  CODEX_FLAGS   extra flags passed to `codex`  (default: empty)

Examples:
  scripts/harness.sh PROMPT.md
  AI_HARNESS=claude scripts/harness.sh PROMPT.md
  scripts/harness.sh --dry-run
EOF
}

for arg in "$@"; do
  case "$arg" in
    -h|--help)  usage; exit 0 ;;
    --dry-run)  DRY_RUN=1 ;;
    -*)         echo "unknown flag: $arg" >&2; usage; exit 2 ;;
    *)          PROMPT_FILE="$arg" ;;
  esac
done

if [ "$DRY_RUN" = "1" ]; then
  echo "[dry-run] harness=$HARNESS prompt=$PROMPT_FILE"
  if command -v "$HARNESS" >/dev/null 2>&1; then
    echo "[dry-run] harness CLI '$HARNESS' resolved at: $(command -v "$HARNESS")"
  else
    echo "[dry-run] harness CLI '$HARNESS' NOT installed"
  fi
  exit 0
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "prompt file not found: $PROMPT_FILE" >&2
  exit 2
fi

# Word-splitting on *_FLAGS is intentional so multiple flags work.
# shellcheck disable=SC2086
case "$HARNESS" in
  pi)     exec pi $PI_FLAGS -p < "$PROMPT_FILE" ;;
  claude) exec claude $CLAUDE_FLAGS -p "$(cat "$PROMPT_FILE")" ;;
  codex)  exec codex $CODEX_FLAGS exec - < "$PROMPT_FILE" ;;
  *) echo "unknown AI_HARNESS: $HARNESS (expected: pi|claude|codex)" >&2; exit 2 ;;
esac
