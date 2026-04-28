---
id: 0007-plan-selection-via-status
title: Plan selection via status frontmatter
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Plan selection via status frontmatter

## Context

Plan `0001-bootstrap-the-last-repo` shipped a `PROMPT.md` whose body
points the agent at one specific plan path
(`docs/plans/platform/0001-bootstrap-the-last-repo.md`). That worked for
the bootstrap loop but does not generalize: every new plan would either
require editing `PROMPT.md` to swap in a new path, or invoking
`scripts/ralph.sh` with a per-plan `PROMPT_FILE` override. The first
option puts plan-routing inside the prompt and turns every plan
hand-off into a manual edit; the second pushes routing into operator
shell history, where it drifts away from the plans folder and is
invisible to every harness reading `AGENTS.md`. Both approaches scale
poorly past a single active plan.

The forces in play:

- **One PROMPT.md, many plans.** The Ralph mandate (ADR `0005`) makes
  `PROMPT.md` the durable contract the driver feeds the harness each
  iteration. If it has to be edited per plan, it is no longer durable;
  if it is durable, it cannot hardcode a plan path.
- **Plan template already mandates `status:` frontmatter.** Plans under
  `docs/plans/<scope>/` carry a `status` field (`draft` /
  `in-progress` / `complete`) by template requirement, so the selection
  signal is already present and authored by the human filing the plan.
  No new metadata field is needed.
- **Progressive disclosure (ADR `0006`).** Routing logic belongs in a
  file the agent already reads (`PROMPT.md`), not in a new layer or in
  a tool only one harness understands. Keeping the algorithm
  prose-described in `PROMPT.md` means every harness — `pi`, `claude`,
  `codex` — gets the same routing for free.
- **Driver simplicity.** `scripts/ralph.sh` is harness-agnostic and
  plan-agnostic by design. Pushing plan selection into the driver
  (e.g. shelling out to `yq` to scan frontmatter) couples the driver
  to the plan format and re-introduces a per-harness divergence point.

The alternatives considered:

- **Per-plan prompt files plus a queue.** Each plan ships a
  `PROMPT.<plan-id>.md`; the driver picks the next prompt file from a
  queue artifact (e.g. `.ralph/queue`). Naturally extends to
  concurrent plans across worktrees, but doubles the per-plan
  authoring cost (file plus queue entry) and puts routing into a
  bespoke queue format that has to be invented and documented. Useful
  only when concurrency becomes a real requirement; out of scope for
  v0.
- **Hardcoded plan path, edited each plan hand-off.** What the
  bootstrap shipped. Cheapest at v0, but every plan transition is a
  manual `PROMPT.md` edit, and the loop's "one durable contract"
  property dies the first time someone forgets.
- **Single self-selecting `PROMPT.md` keyed off `status`.** One
  durable prompt; the agent globs `docs/plans/**/*.md` each iteration,
  filters on `status`, and picks the first plan and first unchecked
  task by a deterministic rule. No new metadata, no driver changes, no
  per-plan files. Single-threaded by construction — concurrent plans
  are deferred to a successor ADR.

The decision is needed *now* because plan
`0002-adopt-plan-selection` is the first plan to land after the
bootstrap, and the bootstrap-era `PROMPT.md` cannot drive it without
either a manual swap or this algorithm. Codifying the rule before
`0002` rewrites `PROMPT.md` keeps the algorithm and the prompt aligned.

## Decision

`PROMPT.md` selects the active plan each iteration by globbing
`docs/plans/**/*.md`, filtering to plans whose frontmatter has
`status: in-progress`, falling back to `status: draft` (auto-promoting
the chosen draft to `in-progress` as the first part of the iteration),
sorting eligible plans by `(scope, id)` ascending, picking the first
plan and the first unchecked task in its §6 Checklist, and creating
the sentinel file `.ralph/COMPLETE` only when no `in-progress` or
`draft` plans remain. Detection is file-based, not transcript-based,
so file edits cannot accidentally trigger a stop (see ADR `0005`
§Decision item 1).

## Consequences

- **Positive:**
  - One durable `PROMPT.md`. New plans come online by `make new-plan`
    and a `status:` value; no prompt edits, no driver flags, no
    per-plan prompt files.
  - The driver (`scripts/ralph.sh`) stays plan-agnostic — all routing
    lives in a file every harness already reads, so the algorithm
    works identically across `pi`, `claude`, and `codex`.
  - Operator control over the queue is preserved: marking a plan
    `in-progress` puts it ahead of `draft` plans, and the
    `(scope, id)` tiebreak makes ordering deterministic without
    inventing a `priority:` field.
  - The completion sentinel is now repo-global rather than per-plan:
    `.ralph/COMPLETE` is created only when the queue is empty, which
    matches what an operator running `make ralph` actually means by
    "done".
- **Negative:**
  - Single-threaded by construction. Two simultaneously active plans
    require a successor ADR (per-plan prompt files plus separate
    worktrees, or similar); this ADR explicitly defers that case.
  - The algorithm relies on `status` hygiene. A plan left as
    `in-progress` with no unchecked boxes will starve the queue;
    `make lint-docs` is the natural place to catch this, but until
    that lint exists the discipline is human-enforced.
  - Auto-promoting a chosen `draft` to `in-progress` mid-iteration
    means the plan file is mutated by the routing step itself, not
    just by the task it runs. Reviewers reading a plan's git history
    will see the status flip arrive in the same iteration as the
    first checkbox tick, which is correct but slightly surprising.
  - The rule is described in prose inside `PROMPT.md`, not encoded in
    a script the agent invokes. Prose is more flexible across
    harnesses but offers no machine-checkable guarantee that a given
    iteration actually followed the algorithm.
- **Follow-ups:**
  - Plan `0002-adopt-plan-selection` t2.01 rewrites `PROMPT.md` to
    implement this algorithm; t2.02 makes `scripts/new-plan.sh`
    default new plans to `status: draft` so they queue behind whatever
    is currently `in-progress`.
  - File a `lint-docs` follow-up (plan `0002` §9) that flags
    `status: in-progress` plans with zero unchecked boxes and that
    optionally warns when more than one plan in the same scope is
    `in-progress` without explicit operator intent.
  - When concurrent plan execution becomes a real requirement, file a
    successor ADR rather than editing this one — the per-plan prompt
    files plus separate worktrees option is the obvious starting
    point.
  - If a `priority:` frontmatter field becomes necessary to break ties
    that `(scope, id)` cannot, file a successor ADR; the current
    tiebreak is sufficient until a real ordering conflict appears.
