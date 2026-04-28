#!/usr/bin/env bash
# ADR generator for The Last Repo.
# Copies docs/adr/TEMPLATE.md into docs/adr/<scope>/<NNNN>-<slug>.md,
# picking the next zero-padded sequence number per scope and seeding the
# frontmatter (id, title, scope, date) so the author only has to fill in
# the body. status, supersedes, and superseded_by are left at their
# template defaults.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$REPO_ROOT/docs/adr/TEMPLATE.md"
BASE_DIR="$REPO_ROOT/docs/adr"

usage() {
  cat <<'EOF'
Usage: scripts/new-adr.sh <scope>/<slug>
       NAME=<scope>/<slug> scripts/new-adr.sh

Creates docs/adr/<scope>/<NNNN>-<slug>.md from docs/adr/TEMPLATE.md.

Arguments:
  <scope>   one of: platform | <service-name> | <app-name> | <package-name>
  <slug>    short, kebab-case, descriptive (no dates, no author names)

The next NNNN is picked per-scope by scanning existing files.

Examples:
  scripts/new-adr.sh platform/use-postgres
  make new-adr NAME=billing/idempotency-keys
EOF
}

NAME="${1:-${NAME:-}}"

case "${NAME}" in
  -h|--help|help) usage; exit 0 ;;
  "") echo "error: NAME (<scope>/<slug>) is required" >&2; usage; exit 2 ;;
esac

if [[ "$NAME" != */* ]]; then
  echo "error: NAME must be of the form <scope>/<slug> (got: $NAME)" >&2
  exit 2
fi

SCOPE="${NAME%%/*}"
SLUG="${NAME#*/}"

if [ -z "$SCOPE" ] || [ -z "$SLUG" ] || [[ "$SLUG" == */* ]]; then
  echo "error: NAME must be exactly <scope>/<slug> (got: $NAME)" >&2
  exit 2
fi

if [[ ! "$SCOPE" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "error: scope must be kebab-case (got: $SCOPE)" >&2
  exit 2
fi
if [[ ! "$SLUG" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "error: slug must be kebab-case (got: $SLUG)" >&2
  exit 2
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "error: template not found: $TEMPLATE" >&2
  exit 2
fi

SCOPE_DIR="$BASE_DIR/$SCOPE"
mkdir -p "$SCOPE_DIR"

# Pick next zero-padded NNNN by scanning existing NNNN-*.md in the scope.
next_num=1
for f in "$SCOPE_DIR"/[0-9][0-9][0-9][0-9]-*.md; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  num=$((10#${base%%-*}))
  if [ "$num" -ge "$next_num" ]; then
    next_num=$((num + 1))
  fi
done
NNNN="$(printf '%04d' "$next_num")"

DEST="$SCOPE_DIR/${NNNN}-${SLUG}.md"
if [ -e "$DEST" ]; then
  echo "error: destination already exists: $DEST" >&2
  exit 2
fi

ID="${NNNN}-${SLUG}"
# Title-case the slug for a human-readable default title.
TITLE="$(echo "$SLUG" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
TODAY="$(date -u +%Y-%m-%d)"

# Seed frontmatter from the template, leaving the body untouched.
awk -v id="$ID" -v title="$TITLE" -v scope="$SCOPE" -v today="$TODAY" '
  BEGIN { in_fm = 0; fm_seen = 0 }
  NR == 1 && /^---$/ { in_fm = 1; fm_seen = 1; print; next }
  in_fm && /^---$/   { in_fm = 0; print; next }
  in_fm && /^id:/    { print "id: " id;       next }
  in_fm && /^title:/ { print "title: " title; next }
  in_fm && /^scope:/ { print "scope: " scope; next }
  in_fm && /^date:/  { print "date: " today;  next }
  { print }
' "$TEMPLATE" > "$DEST"

echo "$DEST"
