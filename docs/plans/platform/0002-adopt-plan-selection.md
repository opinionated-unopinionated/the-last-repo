---
id: 0002-adopt-plan-selection
title: Adopt status-based plan selection for the Ralph loop
status: complete
scope: platform
owner: TBD
created: 2026-04-27
updated: 2026-04-27
loop_driver: scripts/ralph.sh
loop_prompt: PROMPT.md
---

# Adopt status-based plan selection for the Ralph loop

## 1. Goal

Replace the hardcoded plan path in `PROMPT.md` with a selection algorithm
that discovers the active plan from `docs/plans/**` frontmatter. After
this plan completes, adding a new plan is `make new-plan` plus a `status:`
value — the loop picks it up automatically with no edits to `PROMPT.md`
or `scripts/ralph.sh`. Implements ADR `0007-plan-selection-via-status`,
which this plan also authors.

## 2. Context

Plan `0001-bootstrap-the-last-repo` ships a `PROMPT.md` whose body points
at `docs/plans/platform/0001-bootstrap-the-last-repo.md` literally. This
worked for the bootstrap loop but does not generalize: every additional
plan would either require editing `PROMPT.md` or invoking the driver with
a per-plan `PROMPT_FILE` override, which puts plan-routing in the wrong
place (operator shell history) and invites drift between the prompt and
the plans folder.

The design conversation that produced this plan settled on option 1 of
two candidates: make `PROMPT.md` plan-selecting (single loop, queue by
`status`) rather than emitting per-plan prompt files. The trade-off
(single-threaded plan execution) is acceptable for v0; concurrent plans
are deferred to a future ADR.

This plan presumes plan `0001-bootstrap-the-last-repo` has reached
`status: complete`. It cannot run earlier because the bootstrap
`PROMPT.md` does not look at this plan. The operator switches the loop
over by pointing `PROMPT.md` at this plan once (manually, before the
first iteration); from t2.01 onward, the rewritten `PROMPT.md` is
self-selecting and no further manual switching is needed.

## 3. Locked decisions

| #  | Topic                          | Choice                                                                  | Rationale                                                                            |
| -- | ------------------------------ | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| 1  | Selection signal               | `status` frontmatter field on plans                                     | Already mandated by the plan template; no new metadata required                      |
| 2  | Selection precedence           | `status: in-progress` first, then `status: draft` (auto-promoted)       | Operator-controlled queue without inventing a `priority:` field                      |
| 3  | Tiebreak among eligible plans  | `(scope, id)` ascending                                                 | Deterministic; matches how plans are already named and filed                         |
| 4  | Concurrency                    | One plan at a time per loop                                             | Defers multi-plan concurrency to a future ADR; keeps the driver plan-agnostic        |
| 5  | Loop driver changes            | None                                                                    | All routing logic lives in `PROMPT.md` where the agent can reason about it           |
| 6  | ADR status on landing          | `accepted`                                                              | Authored and merged as part of this plan; matches the convention from ADR `0001`     |

## 4. Target state

- `docs/adr/platform/0007-plan-selection-via-status.md` exists with
  `status: accepted`, in the format established by ADR `0001` and the
  ADR template.
- `PROMPT.md` no longer references any specific plan path. Instead it
  instructs the agent to discover the active plan each iteration by
  globbing `docs/plans/**/*.md` and filtering on `status` per ADR
  `0007`. The one-task-per-iteration rule from ADR `0005` is preserved
  verbatim.
- `scripts/new-plan.sh` produces new plans with `status: draft` by
  default, so freshly generated plans do not pre-empt whatever is
  currently `in-progress`.
- This plan's frontmatter is `status: complete` and the
  `.ralph/COMPLETE` sentinel was created on the final iteration.

## 5. Approach

Sequencing is dictated by what each task depends on:

1. **Author the ADR first (t1.01).** Subsequent tasks cite it; the agent
   doing t2.01 must be able to read the ADR to know what algorithm to
   write.
2. **Rewrite `PROMPT.md` (t2.01) before any other implementation task.**
   From the iteration after t2.01, the loop self-selects via `status`
   instead of relying on an operator-provided prompt path. This plan
   stays `status: in-progress` across the t2.01 boundary, so the next
   iteration still picks it up under the new algorithm.
3. **Update `scripts/new-plan.sh` (t2.02) last among the implementation
   tasks.** It depends on `scripts/new-plan.sh` existing, which is
   bootstrap task t4.04 — this plan presumes that task is already
   checked off.
4. **Verification (Phase 3) follows implementation.** Smoke-test the new
   selection behavior by inspection (no live multi-plan run is needed at
   this stage) and close the plan.

Out of scope for this plan, deferred to §9: a `lint-docs` check that
flags `status: in-progress` plans with zero unchecked boxes; concurrent
plan execution.

## 6. Checklist (Ralph iterates here)

> One iteration = one checkbox. Pick the first unchecked item. Do only
> that. Check it off. Exit. The driver re-invokes with fresh context.

### Phase 1 — Record the decision

- [x] **t1.01** Create `docs/adr/platform/0007-plan-selection-via-status.md` with `status: accepted`, scope `platform`, date `2026-04-27`. Format per `docs/adr/TEMPLATE.md`. Content: capture the context (hardcoded plan path in `PROMPT.md` does not generalize; two design candidates considered), the decision (PROMPT.md selects the active plan each iteration by globbing `docs/plans/**/*.md`, filtering to `status: in-progress` then `status: draft`, sorting by `(scope, id)`, picking the first plan and the first unchecked task in its §6; emits `<promise>COMPLETE</promise>` only when no `in-progress` or `draft` plans remain), and the consequences (one durable PROMPT.md; driver stays plan-agnostic; single-threaded by construction; relies on `status` hygiene). Cross-reference ADRs `0005` (Ralph mandate) and `0006` (progressive disclosure).

### Phase 2 — Implement the decision

- [x] **t2.01** Rewrite `PROMPT.md` to implement the algorithm from ADR `0007`. Replace the hardcoded plan path with: glob `docs/plans/**/*.md`; filter to `status: in-progress`, fall back to `status: draft` (auto-promote chosen draft to `in-progress` as the first part of the iteration); sort by `(scope, id)` ascending; pick the first plan and the first unchecked task in its §6 Checklist; on completing a plan's last box, set its frontmatter to `status: complete`; emit `<promise>COMPLETE</promise>` only when no `in-progress` or `draft` plans remain. Preserve the existing one-task-per-iteration rules and log-line format. Keep the file readable as a prompt — describe behavior, do not paste pseudocode unless it aids clarity.
- [x] **t2.02** Update `scripts/new-plan.sh` so newly generated plans land with `status: draft` instead of any other default. Single-line change to whatever placeholder the generator emits. Verify by running `bash scripts/new-plan.sh platform/throwaway-test` (then `rm` the throwaway file) and confirming the frontmatter contains `status: draft`.

### Phase 3 — Verify and close

- [x] **t3.01** Inspect `PROMPT.md` and confirm: no plan path is hardcoded; the selection algorithm matches ADR `0007`; the file still fits the prompt-style of plan `0001`'s era (terse, instructional, no pseudocode dumps). If a discrepancy is found, leave this task checked and file a follow-up plan rather than re-editing `PROMPT.md` in this iteration.
- [x] **t3.02** Edit this plan's frontmatter: set `status: complete` and bump `updated` to today's UTC date. Then exit. The next iteration will find no `in-progress` or `draft` plans and create the `.ralph/COMPLETE` sentinel per PROMPT.md, terminating the loop.

## 7. Loop Recipe

```bash
# Prerequisite (one-time, before the first iteration of this plan):
# point PROMPT.md at this plan, since the bootstrap-era prompt
# hardcoded plan 0001's path. After t2.01 lands, this manual step
# is no longer needed for any future plan.
#
# From repo root:
bash scripts/ralph.sh
```

Manual one-shot equivalent (no script):

```bash
mkdir -p .ralph/logs
rm -f .ralph/COMPLETE
while true; do
  rm -f .ralph/COMPLETE
  pi -p < PROMPT.md | tee -a .ralph/logs/last.log
  [ -f .ralph/COMPLETE ] && break
done
rm -f .ralph/COMPLETE
```

The loop must:

1. Re-read `AGENTS.md` and this plan each iteration (fresh context).
2. Pick the first unchecked checkbox in §6.
3. Implement only that task. No bundling.
4. Check the box (`- [ ]` → `- [x]`).
5. Append a one-line summary to `.ralph/logs/last.log`.
6. Exit. The driver restarts with new context.
7. When the queue is drained (no `in-progress` or `draft` plans remain anywhere), create the `.ralph/COMPLETE` sentinel per PROMPT.md.

## 8. Acceptance criteria

1. `docs/adr/platform/0007-plan-selection-via-status.md` exists with `status: accepted` and matches the ADR template structure.
2. `PROMPT.md` contains no hardcoded plan path; the active plan is discovered via `status` frontmatter per ADR `0007`.
3. Running `bash scripts/ralph.sh` against a repo whose only `in-progress` plan is this one continues to drive the iteration that closes it (i.e. the new selection algorithm correctly handles the trivial single-plan case).
4. `bash scripts/new-plan.sh platform/<slug>` emits a plan whose frontmatter has `status: draft`.
5. This plan's frontmatter is `status: complete` and `.ralph/logs/last.log` shows the iteration that created `.ralph/COMPLETE`.

## 9. Open questions (revisit, do not block v0)

- Add a `lint-docs` rule that fails when a plan with `status: in-progress` has zero unchecked boxes in §6, or when more than one plan in the same scope shares `status: in-progress` without explicit operator intent. File as a follow-up plan once `make lint-docs` (bootstrap t5.01) is in place.
- Define how concurrent plan execution would work (per-plan prompt files plus separate worktrees) in a successor ADR if and when the need is real. Out of scope here.
- Decide whether `PROMPT.md` should also recognize a `priority:` frontmatter field for finer-grained ordering, or whether `(scope, id)` plus the `draft` / `in-progress` distinction stays sufficient. Defer until a real ordering conflict appears.

### Notes from iterations

Append short, dated notes when an iteration makes a non-obvious judgment call (e.g. interpreting an ambiguous task, working around an upstream issue). Keeps the audit trail in-band so the next iteration does not relitigate it.

- 2026-04-27 (t3.02): Marked plan complete and bumped `updated` to today (no-op date-wise; same UTC day as creation). The task narrative predicts the next iteration creates `.ralph/COMPLETE`, but plan `0003-align-completion-sentinel-references` is now `status: draft`, so the next iteration will auto-promote and pick it up instead. Sentinel deferred to whichever iteration drains the queue.
