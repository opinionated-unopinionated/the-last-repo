---
id: 0005-ralph-loop-mandate
title: Ralph loop is the mandated workflow for non-trivial work
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Ralph loop is the mandated workflow for non-trivial work

## Context

The Last Repo is built around the [Ralph Wiggum loop](https://ghuntley.com/ralph/): a coding agent is invoked repeatedly with a fixed prompt against a checklist plan, picks the first unchecked task, performs only that task, checks it off, and exits. The driver re-invokes the harness with fresh context. The plan file and an append-only iteration log are the only persistence between iterations.

The forces in play:

- **Context-window discipline.** Long-running agentic sessions accumulate context, drift, and bundle drive-by changes. A loop that resets the context window every iteration trades cleverness for reproducibility — the same plan, replayed, produces a comparable trace.
- **Auditability.** A scaffold that asks contributors to trust AI-driven changes has to make those changes inspectable after the fact. One commit per iteration, one log line per iteration, and a checklist that records what was attempted in what order is the cheapest auditability mechanism that still works for solo contributors.
- **Harness-agnosticism.** Locked decision #5 in plan `0001-bootstrap-the-last-repo` §3 keeps `AGENTS.md` as the single source of truth so any harness can drive the loop. The workflow contract has to live in artifacts every harness reads — not in a single tool's configuration.
- **Self-bootstrapping.** This repo's first plan (`0001-bootstrap-the-last-repo`) is built by the same loop it teaches. If the workflow is optional, the bootstrap is theatre; if it is mandated, the scaffold proves the loop works on day one.

The alternatives considered:

- **No mandate; documentation-only encouragement.** Contributors read `CONTRIBUTING.md`, learn about the loop, and use it when they feel like it. Cheapest, but the loop's value compounds only when it is the default — drive-by ad-hoc PRs erode the audit trail and the comparability that motivates the workflow.
- **Single-mechanism enforcement.** Pick one of: `scripts/ralph.sh` driver, `AGENTS.md` mandate, plan-template requirement, or a CI guard on `docs/plans/**` and `docs/specs/**` PRs. Each mechanism alone has a gap — a driver does not stop someone from skipping it; a mandate in `AGENTS.md` is honored only when the agent reads it; a plan template only triggers when someone files a plan; a CI guard only runs on PRs. Any one mechanism is bypassable without anyone noticing.
- **All four mechanisms layered together.** Locked decision #4 in plan `0001-bootstrap-the-last-repo` §3. The driver is the happy path, `AGENTS.md` is the contract every harness reads, the plan template forces every plan to be loop-runnable, and the CI guard catches plan/spec PRs that bypass the loop. Each mechanism backstops the others — a contributor who skips one is caught by the next.

The decision is needed *now* because Phases 4–6 of the bootstrap plan (`scripts/ralph.sh`, the plan template at `docs/plans/TEMPLATE.md`, and `.github/workflows/ralph-guard.yml`) all need a single answer to "is the loop optional or mandatory?" before they are wired up.

## Decision

Non-trivial work in this repo is performed via the Ralph loop, and the mandate is enforced through four layered mechanisms that together make ad-hoc bypass visible:

1. **Loop driver** — `scripts/ralph.sh` (and the `make ralph` target) re-invoke the chosen harness against `PROMPT.md` until the agent creates the sentinel file `.ralph/COMPLETE` (signalling that no `in-progress` or `draft` plans remain). Detection is file-based, not transcript-based, so file edits cannot accidentally trigger a stop.
2. **`AGENTS.md` mandate** — the canonical agent-context file declares the loop is the contract: one task per iteration, no bundling, no inventing tasks, plan-file-as-only-persistence.
3. **Plan template** — every plan under `docs/plans/<scope>/` must include a §6 Checklist and a §7 Loop Recipe so the driver can run it; `docs/plans/TEMPLATE.md` enforces this structurally.
4. **CI guard** — `.github/workflows/ralph-guard.yml` fails PRs that change `docs/plans/**` or `docs/specs/**` without either a corresponding entry in `.ralph/logs/` or a `Ralph-Run: <plan-id>` commit trailer.

## Consequences

- **Positive:**
  - The loop's audit trail is real: every non-trivial change ties back to a plan file, an iteration log, and a commit trailer, all greppable from the repo root.
  - Each mechanism is bypassable on its own; together they make bypass require deliberate effort across four artifacts (driver, AGENTS.md, template, CI), which is the level of friction the mandate is designed to impose.
  - The contract lives in `AGENTS.md` and the plan template — files every harness reads — so the mandate survives a harness swap (decision #5) and does not depend on `pi`-specific behavior (decision #6 / ADR `0004-pi-as-default-harness`).
  - The bootstrap plan itself runs under this mandate, so the scaffold's first artifact is also its first proof that the loop works.
  - Trivial PRs (typo fixes, single-file dependency bumps) can still ship without a plan; the CI guard scopes the requirement to changes under `docs/plans/**` and `docs/specs/**`, which is where loop-driven work necessarily leaves its trace.
- **Negative:**
  - Four enforcement points means four places to keep in sync — a change to the loop contract has to land in the driver, `AGENTS.md`, the plan template, and the CI guard together, or the layers disagree.
  - The mandate raises the floor for contribution: a one-line doc fix to a plan file requires either an iteration log or a commit trailer, which will surprise contributors who expect "just edit the markdown".
  - The CI guard is heuristic — it checks for an entry in `.ralph/logs/` or a `Ralph-Run:` trailer, but cannot verify the loop actually ran; a determined contributor can satisfy the check without honoring the workflow.
  - Loops are slower than ad-hoc multi-step sessions for work that genuinely is one bundled change; the mandate trades that wall-clock cost for the audit trail and reproducibility.
- **Follow-ups:**
  - `scripts/ralph.sh` (`t4.01`) implements the driver loop, harness dispatch, and iteration cap; the driver — not this ADR — owns the per-iteration mechanics.
  - `docs/plans/TEMPLATE.md` (`t3.06`) carries the §6 Checklist + §7 Loop Recipe requirement; new plans created via `make new-plan` inherit it automatically.
  - `.github/workflows/ralph-guard.yml` (`t6.02`) implements the CI guard; if its heuristic proves too loose or too strict in practice, tighten it there rather than editing this ADR.
  - If the loop contract evolves (different per-iteration rules, a different completion sentinel, a different log format), file a successor ADR rather than editing this one.
