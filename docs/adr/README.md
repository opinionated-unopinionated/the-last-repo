# `docs/adr/` — Architecture Decision Records

An ADR captures **a decision that constrains future code** — a tech choice, a layout rule, a policy — together with the context that forced it and the consequences it locks in. Specs (`docs/specs/`) describe *what and why* a feature exists; plans (`docs/plans/`) describe *how* the work is executed; ADRs preserve the *why behind the rules everything else has to live with*.

The format is [Michael Nygard's ADR](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions): short, immutable, status-tracked, one decision per file.

## When to write an ADR

Write one when:

- A choice will constrain code or process in a way that is **not obvious from reading the diff** months later (e.g. "why Make and not Bazel?", "why is `AGENTS.md` the canonical AI context?").
- A decision is reversible only at meaningful cost (tooling lock-in, migration burden, public API shape).
- A debate has concluded and the reasoning would otherwise live only in chat history.
- A previous ADR is being revisited — write the new one and mark the old one `superseded`.

Skip the ADR for:

- Implementation details internal to one service or package — those belong in code comments or that scope's README.
- Reversible style or formatting preferences — put them in `.editorconfig`, lint configs, or `CONTRIBUTING.md`.
- Decisions still under active debate — wait until there is a decision to record.

If unsure, write one. ADRs are cheap; lost rationale is expensive.

## Naming

```
docs/adr/<scope>/<NNNN>-<slug>.md
```

- `<scope>` is one of: `platform/`, `<service-name>/`, `<app-name>/`, `<package-name>/`. Match the directory the decision constrains.
- `<NNNN>` is a zero-padded four-digit sequence number, **per scope** (`docs/adr/platform/0001-…` and `docs/adr/billing/0001-…` coexist).
- `<slug>` is short, kebab-case, and reads as a noun phrase describing the decision (`record-architecture-decisions`, `monorepo-layout`, `pi-as-default-harness`). No dates, no author names.

Use the generator — it picks the next number and copies the template:

```bash
make new-adr NAME=<scope>/<slug>
```

## Status lifecycle

ADRs are **immutable in intent**. The status field is the only thing that changes after acceptance.

| Status | Meaning |
| --- | --- |
| `proposed` | Drafted, under discussion in a PR. Not yet binding. |
| `accepted` | Merged. The decision is in force; downstream code and process must respect it. |
| `superseded` | A newer ADR replaces this one. Both frontmatters cross-link (`superseded-by:` here, `supersedes:` there). The original text stays as-is — it is the historical record. |
| `deprecated` | The decision is no longer in force but no replacement was needed (the constraint went away). Rare; prefer `superseded` when a successor exists. |
| `rejected` | Considered and explicitly declined. Recorded so the same idea is not relitigated from scratch. |

Never edit the body of an `accepted` ADR to change the decision — write a successor and supersede the old one. Typo fixes and link repairs are fine; substantive changes are not.

## Scope rules

- One decision per ADR. If you find yourself writing "and also…", split it.
- ADR scope must match the code scope it constrains. A decision affecting only `services/billing/` lives under `docs/adr/billing/`. Cross-cutting concerns belong under `platform/`.
- ADRs reference specs and plans, not the other way around. A spec may cite the ADR that constrained it; a plan may cite the ADR it is implementing under.
- Keep ADRs short. Nygard's original prescription is roughly one page. If yours is longer, the decision is probably more than one decision.

## Reading order

When picking up unfamiliar work, scan `docs/adr/<scope>/` for accepted decisions touching that scope before proposing changes — they are the rules everything else is built on top of. Do not pre-read sibling scopes; load lazily, per `AGENTS.md`.

The template (`docs/adr/TEMPLATE.md`) is loaded only when authoring a new ADR.
