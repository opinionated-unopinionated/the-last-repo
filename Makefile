# The Last Repo — Makefile
#
# Single entry point for the day-to-day operations: running the Ralph loop,
# generating new specs/plans/ADRs from templates, linting docs, and the local
# CI bundle. Run `make help` for the documented targets.

SHELL       := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

# Generators expect NAME=<scope>/<slug>. Default to empty so the underlying
# script prints its own usage when NAME is omitted.
NAME ?=

.PHONY: help ralph new-spec new-plan new-adr lint-docs ci

help: ## Show this help
	@awk 'BEGIN { FS = ":.*##"; printf "Usage: make <target>\n\nTargets:\n" } \
	     /^[a-zA-Z0-9_.-]+:.*##/ { printf "  %-12s  %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

ralph: ## Run the Ralph loop driver (AI_HARNESS=pi|claude|codex)
	@bash scripts/ralph.sh

new-spec: ## Create a new spec  (usage: make new-spec NAME=<scope>/<slug>)
	@bash scripts/new-spec.sh "$(NAME)"

new-plan: ## Create a new plan  (usage: make new-plan NAME=<scope>/<slug>)
	@bash scripts/new-plan.sh "$(NAME)"

new-adr: ## Create a new ADR    (usage: make new-adr  NAME=<scope>/<slug>)
	@bash scripts/new-adr.sh "$(NAME)"

lint-docs: ## Lint Markdown in docs/ and root *.md
	@if command -v markdownlint-cli2 >/dev/null 2>&1; then \
	  markdownlint-cli2 "docs/**/*.md" "*.md" "#node_modules" "#.ralph"; \
	elif command -v markdownlint >/dev/null 2>&1; then \
	  markdownlint docs/ *.md; \
	else \
	  echo "lint-docs: no markdown linter installed (install markdownlint-cli2 or markdownlint); skipping"; \
	fi

ci: lint-docs ## Run local CI checks: lint-docs + shellcheck + tree integrity
	@if command -v shellcheck >/dev/null 2>&1; then \
	  shellcheck scripts/*.sh; \
	else \
	  echo "ci: shellcheck not installed; skipping shell lint"; \
	fi
	@set -e; \
	  test -f AGENTS.md   || { echo "ci: AGENTS.md missing"; exit 1; }; \
	  test -L CLAUDE.md   || { echo "ci: CLAUDE.md must be a symlink to AGENTS.md"; exit 1; }; \
	  [ "$$(readlink CLAUDE.md)" = "AGENTS.md" ] || { echo "ci: CLAUDE.md must point to AGENTS.md"; exit 1; }; \
	  test -f PROMPT.md   || { echo "ci: PROMPT.md missing"; exit 1; }; \
	  test -f LICENSE     || { echo "ci: LICENSE missing"; exit 1; }; \
	  test -x scripts/ralph.sh || { echo "ci: scripts/ralph.sh must be executable"; exit 1; }; \
	  echo "ci: tree integrity OK"
