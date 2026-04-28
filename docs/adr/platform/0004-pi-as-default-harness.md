---
id: 0004-pi-as-default-harness
title: pi as default AI harness
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# pi as default AI harness

## Context

The Last Repo is harness-agnostic by design — locked decision #5 in plan `0001-bootstrap-the-last-repo` §3 keeps `AGENTS.md` as the single source of truth so any AI coding agent can drive the Ralph loop. But "harness-agnostic" only describes the contract; the repo still has to pick *one* harness as the default that `scripts/ralph.sh`, the `make ralph` target, and the documentation invoke when no `AI_HARNESS` override is set. Without a default, the loop driver has nothing to dispatch to and `make help` cannot point a brand-new contributor at a single working command.

The candidates were the three harnesses the repo already supports through `scripts/harness.sh`:

- **[`@mariozechner/pi-coding-agent`](https://www.npmjs.com/package/@mariozechner/pi-coding-agent) (`pi`).** Reads `AGENTS.md` natively, ships as an `npm` package installable in one command, is model- and provider-agnostic at the harness layer, and runs unattended in the kind of tight read-edit loop that Ralph requires. The author of this repo uses it day-to-day, so it is the harness most likely to be exercised against the loop's edge cases.
- **`claude` (Claude Code).** Reads `CLAUDE.md`, which the symlink in t1.04 points at `AGENTS.md`, so the canonical-context contract still holds. Strong tooling and IDE integration, but tied to a single model vendor and a separate install/auth flow that is heavier than `npm i -g`.
- **`codex` (OpenAI Codex CLI).** Also reads `AGENTS.md` natively, also vendor-coupled, also a separate install/auth flow.

All three satisfy the canonical-context contract (decision #5) and all three are wired into `scripts/harness.sh` so any of them can drive the loop. The differentiators that mattered:

- **Install friction.** `npm i -g @mariozechner/pi-coding-agent` is the shortest path from a fresh clone to a running loop. Codex and Claude Code both require provider-specific install and auth steps before the first iteration.
- **Vendor neutrality at the harness layer.** Picking a vendor-coupled harness as the default would quietly bias an OSS scaffold toward one model provider, even though the repo deliberately exposes `AI_HARNESS` to keep that choice in the user's hands.
- **Author-tested defaults.** The maintainer runs `pi` against this repo; it will get the most real-world iteration mileage and surface bugs in the loop contract first.

The decision is needed *now* because Phase 4 of the bootstrap plan (`t4.01`–`t4.02`) wires up `scripts/ralph.sh` and `scripts/harness.sh`, both of which need a single answer to "what runs when nothing is set?".

## Decision

The repo defaults `AI_HARNESS` to `pi` (`@mariozechner/pi-coding-agent`) for the Ralph loop driver and all documentation, while keeping `claude` and `codex` as first-class supported alternates selectable via the `AI_HARNESS` environment variable.

## Consequences

- **Positive:**
  - One-command bootstrap: a fresh clone plus `npm i -g @mariozechner/pi-coding-agent` plus `make ralph` is enough to run the loop, matching the zero-friction posture set by ADR `0003-make-as-orchestrator`.
  - The default harness is a model- and provider-agnostic layer, so the OSS scaffold does not advertise a single AI vendor on its front page.
  - `AGENTS.md` stays canonical; the `CLAUDE.md` symlink and Codex's native `AGENTS.md` support mean the alternates are real options, not afterthoughts — a contributor preferring Claude Code or Codex sets `AI_HARNESS=claude` (or `codex`) and gets the same loop behavior.
  - Per-harness flag passthroughs (`PI_FLAGS`, `CLAUDE_FLAGS`, `CODEX_FLAGS`) keep harness-specific tuning out of the driver, so swapping defaults later is a one-line change in `scripts/ralph.sh`.
- **Negative:**
  - `pi` requires a Node toolchain to install, which the repo's bootstrap otherwise avoids — the orchestrator (Make) is zero-install but the default harness is not.
  - Defaulting to a single harness means its quirks (CLI ergonomics, prompt format, exit-code behavior) shape the loop's tested-good path; the alternates may surface inconsistencies that only the default exercises.
  - `pi` is a younger, smaller-ecosystem tool than Claude Code or Codex; if it stops being maintained, this ADR has to be superseded, not edited.
- **Follow-ups:**
  - `scripts/harness.sh` (`t4.02`) implements the dispatch table; the dispatcher — not this ADR — owns the per-harness invocation details.
  - `README.md` and `CONTRIBUTING.md` document the install line for `pi` and call out `AI_HARNESS=claude|codex` as supported alternates; keep those pointers in sync if the default ever changes.
  - If `pi` is ever retired, deprecated, or substantially diverges from the loop contract, file a successor ADR pointing at the new default rather than editing this one.
