---
name: Spec proposal
about: Propose a new spec — a "what and why" intent doc — that should land under `docs/specs/<scope>/`.
title: "spec: <short summary>"
labels: ["spec", "triage"]
assignees: []
---

<!--
Specs answer **what** and **why**, not how. Plans (`docs/plans/<scope>/`)
describe the *how*; ADRs (`docs/adr/<scope>/`) capture *constraining decisions*.

Before filing: skim `docs/specs/` for related intent and `docs/specs/README.md`
for scope rules. The full template lives at `docs/specs/TEMPLATE.md` — when this
issue is accepted, run `make new-spec NAME=<scope>/<slug>` to draft it.
-->

## Summary

<!-- One sentence: what user-visible outcome should the spec describe? -->

## Goal

<!-- One short paragraph. State the user-visible outcome and the problem it
solves. A future reader should be able to reconstruct intent from this alone.
This will become §1 of the spec. -->

## Non-goals

<!-- What this spec deliberately does NOT cover. Calling out non-goals up front
is how we keep scope honest. -->

-
-

## User stories

<!-- One bullet per role, in canonical form so acceptance criteria can map back. -->

- As a **…**, I want **…** so that **…**.
- As a **…**, I want **…** so that **…**.

## Acceptance signals

<!-- Observable, behaviour-focused outcomes. Avoid implementation language
("uses Redis") in favour of observable behaviour ("survives a process restart
without data loss"). The spec will formalise these as numbered acceptance
criteria. -->

-
-

## Scope

- Scope (folder under `apps/`, `services/`, `packages/`, `tools/`, or `platform`):
- Proposed slug (`docs/specs/<scope>/<slug>`):
- Supersedes an existing spec? (link if yes):

## Open questions

<!-- Unresolved items that should not block drafting. Each one should graduate
into another spec, an ADR, or a plan — do not silently drop them. -->

-
-

## Next step

<!-- Once this issue is accepted, draft the spec via:

    make new-spec NAME=<scope>/<slug>

then fill out `docs/specs/<scope>/<NNNN>-<slug>.md` using the canonical template
at `docs/specs/TEMPLATE.md`. Link the resulting spec back to this issue. -->

## Additional context

<!-- Links to related specs, plans, ADRs, bugs, or upstream prior art. -->
