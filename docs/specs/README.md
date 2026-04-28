# `docs/specs/` — Specs

A spec captures **what** is being built and **why**, before any code is written. It is the source of truth for product/feature intent. Plans (`docs/plans/`) describe the *how*; ADRs (`docs/adr/`) capture *constraining decisions*. Specs answer the *what and why*.

## When to write a spec

Write one when:

- A new feature, behavior change, or user-visible product decision needs description before implementation.
- A behavior change is significant enough that a future reader (human or agent) cannot reconstruct the intent from the diff.
- A non-trivial PR is being opened — CI and `CONTRIBUTING.md` expect a linked spec for substantive changes.

Skip the spec for:

- Pure refactors with no behavior change.
- Bug fixes whose intent is already obvious from the failing test.
- Doc-only updates.

If unsure, write one. Specs are cheap; missing context is expensive.

## Naming

```
docs/specs/<scope>/<NNNN>-<slug>.md
```

- `<scope>` is one of: `platform/`, `<service-name>/`, `<app-name>/`, `<package-name>/`. Match the directory the work targets.
- `<NNNN>` is a zero-padded four-digit sequence number, **per scope** (`docs/specs/platform/0001-…` and `docs/specs/billing/0001-…` coexist).
- `<slug>` is short, kebab-case, descriptive. No dates, no author names.

Use the generator — it picks the next number and copies the template:

```bash
make new-spec NAME=<scope>/<slug>
```

## Scope rules

- One spec per cohesive feature or decision. Do not bundle unrelated changes.
- Spec scope must match the code scope. A spec under `docs/specs/billing/` describes work in `services/billing/` (or `apps/billing/`). Cross-cutting concerns belong under `platform/`.
- Specs are immutable in intent: amend with follow-up specs rather than rewriting history. Small clarifications are fine; substantive direction changes deserve a new spec that supersedes the old one (note this in the frontmatter).
- A spec **does not** prescribe implementation order. That is the plan's job. If you find yourself writing a checklist, you want a plan.

## Lifecycle

1. **Draft** — author fills `TEMPLATE.md` via `make new-spec`.
2. **Reviewed** — discussed in PR; acceptance criteria locked.
3. **Implemented** — referenced by one or more plans under `docs/plans/<scope>/`.
4. **Superseded** — when intent changes, a newer spec replaces it; update both frontmatters.

The template (`docs/specs/TEMPLATE.md`) is loaded only when authoring a new spec.
