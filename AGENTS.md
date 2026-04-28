# AGENTS.md — The Last Repo

You are an AI coding agent working in this repository. This file is your entry point. Read it first, then load only what you need for the task in front of you. The repo follows **progressive disclosure**: smallest, most general context first; deeper docs are fetched on demand.

## Reading order

1. **This file.** Orientation, mandates, and pointers.
2. **`docs/README.md`** — map of `specs/`, `plans/`, `adr/` and their scoped subfolders.
3. **The relevant scoped folder** — e.g. `docs/plans/<scope>/` when implementing a plan, `docs/adr/<scope>/` when checking past architectural decisions.
4. **Templates** (`docs/<type>/TEMPLATE.md`) — load only when authoring a new doc of that type.

Do not pre-read templates or unrelated scopes. Load context lazily.

## Key paths

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Canonical AI context (this file). `CLAUDE.md` is a symlink to it. |
| `PROMPT.md` | Default Ralph loop prompt fed to the harness each iteration. |
| `scripts/ralph.sh` | Loop driver. Re-invokes the chosen harness until the agent creates the sentinel file `.ralph/COMPLETE`. |
| `scripts/harness.sh` | Dispatches to `pi`, `claude`, or `codex`. |
| `scripts/new-{spec,plan,adr}.sh` | Generators that copy the matching template into `<scope>/<NNNN>-<slug>.md`. |
| `Makefile` | One entry point for `ralph`, `new-*`, `lint-docs`, `ci`. Run `make help`. |
| `docs/specs/` | Product/feature intent. What and why. |
| `docs/plans/` | Executable checklists. How and in what order. Each plan must have a §6 Checklist and §7 Loop Recipe. |
| `docs/adr/` | Architectural decisions, Nygard-style. |
| `apps/`, `services/`, `packages/`, `tools/` | Polyglot monorepo shells. Each has a README defining conventions. |
| `.ralph/logs/last.log` | Ralph loop iteration log. Append-only, one line per iteration. |

## The Ralph-loop mandate

Non-trivial work in this repo is driven by a [Ralph Wiggum loop](https://ghuntley.com/ralph/), not by ad-hoc multi-step sessions. The loop is the contract:

- A **plan** under `docs/plans/<scope>/<NNNN>-<slug>.md` defines the work as a checklist.
- The harness is invoked via `scripts/ralph.sh` (or `make ralph`) with `PROMPT.md`.
- Each iteration: read this file, read the active plan, pick the **first unchecked task**, do **only that task**, check the box, append one line to `.ralph/logs/last.log`, exit.
- The driver re-invokes with **fresh context**. You do not remember the previous iteration. The plan file and the log are the only persistence.
- When every task is checked, mark the plan `status: complete`. When no `in-progress` or `draft` plans remain, signal completion by creating the sentinel file `.ralph/COMPLETE` (e.g. `touch .ralph/COMPLETE`). The driver detects this file's presence — do not rely on transcript output, since file edits could echo any sentinel string.

Rules every iteration honors:

- **One task per iteration.** No bundling, no drive-by fixes.
- **Never delete or reorder tasks.** If a task is wrong, leave it checked and file a follow-up plan.
- **Never invent tasks.** If a task is ambiguous, do the smallest reasonable thing and add a note under the plan's Open questions section.
- **Edit existing files** in preference to creating new ones, unless the plan tells you to create.
- **Match conventions** defined in templates and ADRs as they come into existence.

PRs that touch `docs/plans/**` or `docs/specs/**` must reference a Ralph run — either an entry in `.ralph/logs/` or a `Ralph-Run: <plan-id>` commit trailer. CI enforces this.

## Harness compatibility

The repo is harness-agnostic. `AGENTS.md` is the single source of truth.

| Harness | How it picks up this file |
| --- | --- |
| `pi` (default — [`@mariozechner/pi-coding-agent`](https://www.npmjs.com/package/@mariozechner/pi-coding-agent)) | Reads `AGENTS.md` natively. |
| `claude` (Claude Code) | Reads `CLAUDE.md`, which is a symlink to `AGENTS.md`. |
| `codex` (OpenAI Codex CLI) | Reads `AGENTS.md` natively. |

Select the harness via `AI_HARNESS=pi|claude|codex` before invoking `scripts/ralph.sh`. Per-harness flags are exposed as `PI_FLAGS`, `CLAUDE_FLAGS`, `CODEX_FLAGS`.

## Authoring new work

- New feature or change in intent → `make new-spec NAME=<scope>/<slug>` and fill in `docs/specs/<scope>/<NNNN>-<slug>.md`.
- New executable plan → `make new-plan NAME=<scope>/<slug>`. Plans must include a Checklist (§6) and a Loop Recipe (§7) so the Ralph driver can run them.
- New architectural decision → `make new-adr NAME=<scope>/<slug>`.

Keep this file under ~100 lines. If you find yourself wanting to add detail here, put it in the relevant `docs/<type>/README.md` or an ADR and link to it from the table above.
