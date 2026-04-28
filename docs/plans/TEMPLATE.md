---
id: NNNN-<slug>
title: <human-readable plan title>
status: draft            # draft | in-progress | complete | superseded
scope: <platform|service-name|app-name|package-name>
owner: TBD
created: YYYY-MM-DD
updated: YYYY-MM-DD
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
- [ ] **t1.01** …
- [ ] **t1.02** …

### Phase 2 — <name>
- [ ] **t2.01** …
- [ ] **t2.02** …

## 7. Loop Recipe

```bash
# From repo root, with the default harness installed.
# To use a different harness: AI_HARNESS=claude  or  AI_HARNESS=codex
bash scripts/ralph.sh
```

Manual one-shot equivalent (no script):

```bash
mkdir -p .ralph/logs
while true; do
  pi -p < PROMPT.md | tee -a .ralph/logs/last.log
  [ -f .ralph/COMPLETE ] && break
done
```

The loop must:
1. Re-read `AGENTS.md` and this plan each iteration (fresh context).
2. Pick the first unchecked checkbox in §6.
3. Implement only that task. No bundling.
4. Check the box (`- [ ]` → `- [x]`).
5. Append a one-line summary to `.ralph/logs/last.log`.
6. Exit. The driver restarts with new context.
7. When all tasks in §6 are checked, set this plan's frontmatter to `status: complete`. The driver-wide sentinel file `.ralph/COMPLETE` is created only when no `in-progress` or `draft` plans remain (see `PROMPT.md`).

## 8. Acceptance criteria

Numbered, testable, behaviour-focused. Each criterion is something a reviewer (or CI) can check after the final iteration. These are the contract — if they pass, the plan is done.

1. …
2. …
3. …

## 9. Open questions (revisit, do not block v0)

Items that came up while authoring or running the plan that are explicitly out of scope here. Each question gets a follow-up: another plan, a spec, or an ADR. Do not silently drop them.

- …
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
