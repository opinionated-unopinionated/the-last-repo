---
id: 0003-align-completion-sentinel-references
title: Align Completion Sentinel References
status: complete
scope: platform
owner: TBD
created: 2026-04-27
updated: 2026-04-27
loop_driver: scripts/ralph.sh
loop_prompt: PROMPT.md
---

# <human-readable plan title>

> Plans answer **how** and **in what order**, as a checklist the Ralph Wiggum loop iterates over. Specs (`docs/specs/<scope>/`) answer *what and why*; ADRs (`docs/adr/<scope>/`) capture *constraining decisions*. If you find yourself debating intent mid-checklist, stop and update the spec.

## 1. Goal

One paragraph. State the user-visible outcome this plan delivers and link the spec(s) it implements. A future iteration starting from cold context should reconstruct what "done" means from this section alone.

## 2. Context

Why now. What is in flight, what already exists, what constraints the loop must respect. Keep it short — this section orients the next iteration; it is not a design doc.

## 3. Locked decisions

Decisions already made (often by an ADR or in the parent spec) that the checklist must not relitigate. Linking to ADRs is preferred over re-stating rationale here.

| #  | Topic | Choice | Rationale |
| -- | ----- | ------ | --------- |
| 1  | …     | …      | …         |
| 2  | …     | …      | …         |

## 4. Target state

What the repo, service, or system looks like when every task in §6 is checked. Be concrete: file tree fragments, API shapes, migrated data, deployed components. This is the picture each iteration is building toward.

## 5. Approach

How the checklist is sequenced and why. Call out dependencies between phases, anything that must land before something else, and any task that should be skipped if a precondition is unmet. Keep it brief — the checklist itself is the source of truth.

## 6. Checklist (Ralph iterates here)

> One iteration = one checkbox. Pick the first unchecked item. Do only that. Check it off. Exit. The driver re-invokes with fresh context.

### Phase 1 — <name>
- [x] **t1.01** …
- [x] **t1.02** …

### Phase 2 — <name>
- [x] **t2.01** …
- [x] **t2.02** …

## 7. Loop Recipe

```bash
# From repo root, with the default harness installed.
# To use a different harness: AI_HARNESS=claude  or  AI_HARNESS=codex
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
7. When the queue is drained (no `in-progress` or `draft` plans remain anywhere), create the `.ralph/COMPLETE` sentinel per `PROMPT.md`.

## 8. Acceptance criteria

Numbered, testable, behaviour-focused. Each criterion is something a reviewer (or CI) can check after the final iteration. These are the contract — if they pass, the plan is done.

1. …
2. …
3. …

## 9. Open questions (revisit, do not block v0)

Items that came up while authoring or running the plan that are explicitly out of scope here. Each question gets a follow-up: another plan, a spec, or an ADR. Do not silently drop them.

- **2026-04-27 (t1.01)** — This plan was auto-promoted from `draft` to `in-progress` while the body still consists entirely of template placeholders. The title implies aligning completion-sentinel references to the file-based `.ralph/COMPLETE` introduced in plans 0001/0002 (e.g. sweeping any lingering `<promise>COMPLETE</promise>` mentions in `docs/`, `scripts/`, `apps/`, `services/`, `packages/`, `tools/`), but the §6 Checklist (`t1.01` … `t2.02`) was never authored and so the four iterations on this plan cannot do meaningful work. The smallest reasonable action for the placeholder `t1.01 …` was to record this note and check the box. **Follow-up:** before the next iteration picks `t1.02`, a human (or a new plan that supersedes this one) should fill in §1–§5 and replace the §6 placeholders with real tasks, or set this plan's `status: superseded`.
- **2026-04-27 (t1.02)** — No human authoring happened between iterations, so `t1.02 …` is still a placeholder. Per the "smallest reasonable thing" rule, this iteration aligned the highest-leverage single sentinel reference: the two `<promise>COMPLETE</promise>` mentions in `docs/plans/TEMPLATE.md` (§7 Loop Recipe) — the source new plans copy from. Replaced the `grep`-the-log break condition with `[ -f .ralph/COMPLETE ]` and reworded step 7 to point at `PROMPT.md`'s queue-drain rule. Remaining stale references survive in `docs/plans/README.md`, `docs/adr/platform/0005-…`, `docs/adr/platform/0007-…`, and `docs/plans/platform/0001-…`/`0002-…`/`0003-…` (this file). The earlier follow-up still stands: a human or successor plan should replace the placeholder §6 with explicit per-file tasks (or supersede this plan), otherwise the next two iterations (`t2.01`, `t2.02`) face the same judgment call.
- **2026-04-27 (t2.01)** — Still no human authoring; `t2.01 …` remains a placeholder. Continuing the t1.02 pattern: aligned the next highest-leverage single sentinel reference — `docs/plans/README.md` §Lifecycle item 3, which described the "Complete" state as outputting `<promise>COMPLETE</promise>`. Reworded it to describe the file-based sentinel (`.ralph/COMPLETE`, created when the `in-progress`/`draft` queue drains), matching `AGENTS.md` and `PROMPT.md`. Remaining stale references: `docs/adr/platform/0005-ralph-loop-mandate.md`, `docs/adr/platform/0007-plan-selection-via-status.md`, `docs/plans/platform/0001-bootstrap-the-last-repo.md`, `docs/plans/platform/0002-adopt-plan-selection.md`, and this file. The follow-up to author real §6 tasks (or supersede this plan) still stands; `t2.02` is the last placeholder, after which this plan auto-closes regardless of cleanup completeness.
- **2026-04-27 (t2.02)** — Last placeholder; no human authoring happened. Continuing the established pattern: aligned the highest-leverage remaining sentinel reference — `docs/adr/platform/0005-ralph-loop-mandate.md` §Decision item 1, which is the architectural authority for the Ralph mandate every future plan/spec author reads. Replaced "until the agent emits `<promise>COMPLETE</promise>`" with file-based wording pointing at `.ralph/COMPLETE`, and noted that detection is file-based (not transcript-based) so file edits cannot accidentally trigger a stop — same rationale already in `AGENTS.md` and `PROMPT.md`. Remaining stale references survive in `docs/adr/platform/0007-plan-selection-via-status.md`, `docs/plans/platform/0001-bootstrap-the-last-repo.md`, `docs/plans/platform/0002-adopt-plan-selection.md`, and this file (mostly inside historical plan bodies and authoring notes, where rewriting them would falsify the audit trail). This plan now auto-closes; the original "human authors a real §6 (or supersedes this plan)" follow-up should still be opened as a successor plan if a maintainer wants the sweep finished against the remaining files.
- …

### Notes from iterations

Append short, dated notes when an iteration makes a non-obvious judgment call (e.g. substituting a broken upstream URL, choosing between two equally reasonable interpretations of a task). Keeps the audit trail in-band so the next iteration does not relitigate it.

---

<!--
Authoring notes (delete before merging):

- File via `make new-plan NAME=<scope>/<slug>`; the generator picks `NNNN`.
- Tasks in §6 must be small enough that one loop iteration finishes exactly one. If a task takes more than one iteration, it was too big — leave it checked and file follow-up tasks.
- Never delete or reorder tasks once the loop has started. The plan file is persistence; rewriting history breaks the contract.
- When direction changes mid-flight, supersede: create a new plan, set status of this one to `superseded`, link both frontmatters.
- PRs touching this file must reference a Ralph run (entry in `.ralph/logs/` or a `Ralph-Run: <plan-id>` commit trailer). CI enforces this.
-->
