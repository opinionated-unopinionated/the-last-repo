---
id: NNNN-<slug>
title: <human-readable spec title>
status: draft            # draft | reviewed | implemented | superseded
scope: <platform|service-name|app-name|package-name>
owner: TBD
created: YYYY-MM-DD
updated: YYYY-MM-DD
supersedes:              # spec id this one replaces, if any
superseded_by:           # spec id that replaces this one, if any
---

# <human-readable spec title>

> Specs answer **what** and **why**, not how. Plans (`docs/plans/<scope>/`) describe the *how*; ADRs (`docs/adr/<scope>/`) capture *constraining decisions*. If you find yourself writing an ordered checklist here, you want a plan.

## 1. Goal

One paragraph. State the user-visible outcome and the problem it solves. A future reader should be able to reconstruct intent from this section alone.

## 2. Non-goals

Bullet list. What this spec deliberately does **not** cover. Linking to a related spec or "deferred to v1" is fine. Calling out non-goals is how you keep scope honest.

- …
- …

## 3. User stories

Bullet list, one per role. Use the canonical form so acceptance criteria can map back cleanly:

> As a **<role>**, I want **<capability>** so that **<outcome>**.

- As a **…**, I want **…** so that **…**.
- As a **…**, I want **…** so that **…**.

## 4. Acceptance criteria

Numbered, testable, behaviour-focused. Each criterion should be something a reviewer (or CI) can check; avoid implementation language ("uses Redis") in favour of observable behaviour ("survives a process restart without data loss").

1. …
2. …
3. …

## 5. Open questions

Things that are unresolved but should not block drafting. Each question gets a follow-up: another spec, an ADR, or a plan. Do not silently drop them — leave them here until they are answered or moved.

- …
- …

---

<!--
Authoring notes (delete before merging):

- File via `make new-spec NAME=<scope>/<slug>`; the generator picks `NNNN`.
- Keep the spec terse. Long specs are a smell — split them.
- Acceptance criteria are the contract a plan implements. Get them right before writing a plan.
- When intent changes substantively, supersede instead of rewriting: create a new spec, set `supersedes:` here and `superseded_by:` on the old one, flip the old `status:` to `superseded`.
-->
