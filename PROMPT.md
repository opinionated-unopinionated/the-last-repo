# Ralph Wiggum Loop — The Last Repo

You are one iteration in a Ralph Wiggum loop. The driver (`scripts/ralph.sh`) re-invokes you with fresh context after you exit. You will not remember this iteration in the next one — the active plan file and `.ralph/logs/last.log` are your only persistence.

## Your job, this iteration only

1. Read `AGENTS.md` (entry point).
2. Select the active plan (algorithm below).
3. In that plan's §6 Checklist, find the first unchecked task (`- [ ] **tX.YY** …`).
4. Implement that task and only that task. No bundling. No drive-by fixes.
5. Edit the plan file to check the box (`- [ ]` → `- [x]`).
6. Append one line to `.ralph/logs/last.log`:
   `<UTC ISO timestamp> tX.YY <one-line summary>`
7. If checking that box leaves §6 with no unchecked tasks, edit the same plan's frontmatter: set `status: complete` and bump `updated` to today's UTC date.
8. If — after that update — no plan under `docs/plans/**/*.md` has `status: in-progress` or `status: draft`, signal completion by creating the sentinel file `.ralph/COMPLETE` (e.g. `touch .ralph/COMPLETE`) and stop. The driver detects this file's presence — do **not** print the literal completion tag, since that would also be matched if it ever appeared in transcripts of file edits.
9. Otherwise, exit normally without creating the sentinel. The driver will start the next iteration.

## How to select the active plan

Per ADR `0007-plan-selection-via-status`, each iteration rediscovers the active plan from scratch — never assume continuity with a previous iteration.

1. Glob every `docs/plans/**/*.md`. Ignore `README.md` and `TEMPLATE.md`.
2. Read each plan's frontmatter and build the candidate set:
   - First, plans whose `status` is `in-progress`.
   - If that set is empty, plans whose `status` is `draft`.
   - Plans with `status: complete` (or any other value) are excluded.
3. Sort the candidate set by `(scope, id)` ascending, using the `scope` and `id` from the frontmatter (not from the file path).
4. The first plan in that sorted list is the active plan for this iteration. If it came from the `draft` fallback, edit its frontmatter to `status: in-progress` before proceeding (auto-promotion). Leave `updated` alone until the iteration that closes the plan.
5. If the candidate set is empty — no `in-progress` and no `draft` plans remain anywhere — create the sentinel file `.ralph/COMPLETE` (e.g. `touch .ralph/COMPLETE`) and stop. The queue is drained.

## Rules

- One task per iteration. The loop relies on this.
- Do not modify or reorder tasks you are not currently working on.
- Do not invent tasks. If a task is ambiguous, do the smallest reasonable thing and add a note under the active plan's §9 "Open questions".
- Match conventions defined in templates and ADRs as they come into existence.
- Prefer editing existing files over creating new ones. The plan tells you what to create.
- Keep `AGENTS.md` under ~100 lines (progressive disclosure).
- Never delete tasks. If a task turns out to be wrong, leave it checked and file a follow-up plan.
