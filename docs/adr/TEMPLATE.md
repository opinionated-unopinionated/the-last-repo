---
id: NNNN-<slug>
title: <human-readable decision title>
status: proposed         # proposed | accepted | superseded | deprecated | rejected
scope: <platform|service-name|app-name|package-name>
date: YYYY-MM-DD
supersedes:              # ADR id this one replaces, if any
superseded_by:           # ADR id that replaces this one, if any
---

# <human-readable decision title>

> ADRs capture **a single decision that constrains future code**, together with the context that forced it and the consequences it locks in. Specs (`docs/specs/<scope>/`) describe *what and why* a feature exists; plans (`docs/plans/<scope>/`) describe *how* the work is executed; ADRs preserve the *why behind the rules everything else has to live with*. Format follows [Michael Nygard's ADR](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions): short, immutable, status-tracked, one decision per file.

## Context

The forces in play. What problem are we solving, what constraints are non-negotiable, what alternatives were on the table, and what made this decision necessary *now*. Describe the situation a future reader would need to understand to find this decision reasonable. Avoid prescribing the decision here — that belongs in §Decision.

## Decision

The choice, stated as a single declarative sentence (or a short paragraph at most). Use active voice: "We will…", "The repo uses…". One decision per ADR. If you need "and also…", split into a second ADR.

## Consequences

What becomes easier, what becomes harder, and what is now locked in as a result. Include both the positive and the negative — ADRs that only list benefits are advertising, not records. Call out any follow-up work this decision creates (new ADRs to write, plans to file, code to migrate).

- **Positive:** …
- **Negative:** …
- **Follow-ups:** …

---

<!--
Authoring notes (delete before merging):

- File via `make new-adr NAME=<scope>/<slug>`; the generator picks `NNNN` per scope.
- Keep it short — Nygard's original prescription is roughly one page. If yours is longer, the decision is probably more than one decision.
- ADRs are immutable in intent. Once `accepted`, never edit the body to change the decision; write a successor and set `superseded_by:` here, `supersedes:` there. Typo fixes and link repairs are fine.
- Reference the ADR from the specs and plans it constrains, not the other way around.
-->
