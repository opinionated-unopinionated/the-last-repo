# `docs/plans/` — Plans

A plan describes **how** work will be done and **in what order**, as a checklist the [Ralph Wiggum loop](https://ghuntley.com/ralph/) can iterate over. Specs (`docs/specs/`) capture *what and why*; ADRs (`docs/adr/`) capture *constraining decisions*; plans turn intent into executable steps.

## When to write a plan

Write one when:

- A spec (or a directly-stated intent) needs to be broken into ordered, atomic tasks.
- The work is non-trivial enough to benefit from one-task-per-iteration execution under `scripts/ralph.sh`.
- You want a durable checklist that survives across fresh-context iterations — the plan file and `.ralph/logs/last.log` are the only persistence the loop has.

Skip the plan for:

- One-shot edits where a single PR is the natural unit of work.
- Mechanical follow-ups already enumerated in another plan's open questions.
- Doc-only typo fixes.

If unsure, write one. Plans are cheap; lost context across iterations is expensive.

## Required sections

Every plan **must** include:

- **§6 Checklist** — atomic tasks formatted as `- [ ] **tX.YY** <task>`. One iteration = one checkbox. Tasks are never deleted or reordered once written; if a task turns out to be wrong, leave it checked and file a follow-up plan.
- **§7 Loop Recipe** — the exact command(s) needed to run the plan under `scripts/ralph.sh`, plus any harness-specific flags. The recipe is what a reader copies to start the loop.

The full section structure lives in [`TEMPLATE.md`](./TEMPLATE.md). CI and `scripts/new-plan.sh` assume that structure.

## Naming

```
docs/plans/<scope>/<NNNN>-<slug>.md
```

- `<scope>` is one of: `platform/`, `<service-name>/`, `<app-name>/`, `<package-name>/`. Match the directory the work targets.
- `<NNNN>` is a zero-padded four-digit sequence number, **per scope** (`docs/plans/platform/0001-…` and `docs/plans/billing/0001-…` coexist).
- `<slug>` is short, kebab-case, descriptive. No dates, no author names.

Use the generator — it picks the next number and copies the template:

```bash
make new-plan NAME=<scope>/<slug>
```

## Scope rules

- One plan per cohesive deliverable. Do not bundle unrelated work — split it.
- Plan scope must match the code scope. A plan under `docs/plans/billing/` drives changes in `services/billing/` (or the matching app/package). Cross-cutting concerns live under `platform/`.
- A plan **implements** a spec (or stated intent); it does not redefine it. If you find yourself debating *what* or *why* mid-checklist, stop and update the spec.
- Tasks in §6 must be small enough that one iteration of the loop can finish exactly one. If a task takes more than one iteration, it was too big — leave it checked and file follow-up tasks.

## Lifecycle

1. **Draft** — author fills `TEMPLATE.md` via `make new-plan`. Status: `draft`.
2. **In progress** — loop has started; at least one task is checked. Status: `in-progress`.
3. **Complete** — every task in §6 is checked. Status: `complete`. When the queue of `in-progress`/`draft` plans drains, the final iteration creates the sentinel file `.ralph/COMPLETE` and the driver stops the loop.
4. **Superseded** — direction changed mid-flight; a newer plan replaces this one. Update both frontmatters.

PRs that touch `docs/plans/**` must reference a Ralph run — either an entry in `.ralph/logs/` or a `Ralph-Run: <plan-id>` commit trailer. CI enforces this.

The template (`docs/plans/TEMPLATE.md`) is loaded only when authoring a new plan.
