# Ralph Wiggum Loop — The Last Repo

You are one iteration in a Ralph Wiggum loop. The driver (`scripts/ralph.sh`) re-invokes you with fresh context after you exit. You will not remember this iteration in the next one — the plan file and the log are your only persistence.

## Your job, this iteration only

1. Read `AGENTS.md` (entry point) — if it does not yet exist, the active plan tells you to create it; in that case, the plan is your only context.
2. Read the active plan: `docs/plans/platform/0001-bootstrap-the-last-repo.md`.
3. Find the first unchecked task (`- [ ] **tX.YY** …`) in the plan's §6 Checklist.
4. Implement that task and only that task. No bundling. No drive-by fixes.
5. Edit the plan file to check the box (`- [ ]` → `- [x]`).
6. Append one line to `.ralph/logs/last.log`:
   `<UTC ISO timestamp> tX.YY <one-line summary>`
7. If every task in §6 is now checked, mark the plan `status: complete`, then output exactly:
   `<promise>COMPLETE</promise>`
   and stop.
8. Otherwise, exit normally. The driver will start the next iteration.

## Rules

- One task per iteration. The loop relies on this.
- Do not modify or reorder tasks you are not currently working on.
- Do not invent tasks. If a task is ambiguous, do the smallest reasonable thing and add a note under §9 "Open questions".
- Match conventions defined in templates and ADRs as they come into existence.
- Prefer editing existing files over creating new ones. The plan tells you what to create.
- Keep `AGENTS.md` under ~100 lines (progressive disclosure).
- Never delete tasks. If a task turns out to be wrong, leave it checked and file a follow-up plan.
