---
id: 0002-monorepo-layout
title: Monorepo layout
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Monorepo layout

## Context

The Last Repo is a polyglot scaffold meant to be cloned and extended by teams whose stacks we cannot predict. It must give a new contributor (human or AI agent) an unambiguous answer to two questions on first contact: *where does my code go?* and *where does the rationale for the rules live?* Without a top-level layout that answers both, every new service negotiates its own home and every architectural rule scatters into chat logs and READMEs.

Several layouts were on the table:

- A flat tree where every project sits at the root. Cheap to start; collapses past a handful of components and gives no place to distinguish a deployable from a library.
- A language-partitioned tree (`go/`, `ts/`, `py/`). Forces a language taxonomy onto teams before they have one, and a single component that spans languages has no clear home.
- A shell of role-based directories with no language commitment, paired with a documentation tree that mirrors the same scoping. This is the [standard Go project layout's](https://github.com/golang-standards/project-layout) philosophy applied repo-wide: structure expresses *role*, not technology, and code lives next to its peers regardless of stack.

The third option matches the repo's polyglot remit (locked decision #1 in plan `0001-bootstrap-the-last-repo` §3) and the documentation tree we already need for specs, plans, and ADRs (locked decision #8). The decision is needed *now* because Phase 2 of the bootstrap plan creates the role-based shells and Phase 3 creates the doc tree; both presume this layout.

## Decision

The repo uses a role-based, language-agnostic top-level layout — `apps/`, `services/`, `packages/`, `tools/` for code, and `docs/{specs,plans,adr}/<scope>/` for documentation — with each role directory carrying a `README.md` that defines its conventions and each documentation type partitioned by `<scope>` (where `<scope>` matches the code scope: `platform/`, an app name, a service name, or a package name).

## Consequences

- **Positive:**
  - A new contributor places code by asking "what role does this play?" — deployable frontend (`apps/`), deployable backend (`services/`), reusable library (`packages/`), local-only utility (`tools/`) — not "what language is this?".
  - Polyglot components live in one place; a service that mixes Go and TypeScript still has a single home under `services/<name>/`.
  - The documentation tree mirrors the code tree's scoping, so a contributor working in `services/billing/` looks in `docs/{specs,plans,adr}/billing/` for the rules and intent, without nesting docs inside the code.
  - Scope is grep-friendly and scales to many components without deepening the directory hierarchy — the flat `<type>/<scope>/` tree was chosen explicitly over nested `<type>/<area>/<scope>/` for this reason.
  - The role-based shells stay empty until a real component arrives, so the scaffold imposes no premature structure on consumers who fork it.
- **Negative:**
  - The `apps/` vs `services/` distinction depends on a convention (frontend deployable vs backend deployable) that the per-directory READMEs must keep crisp; teams that conflate the two will end up with mis-scoped components.
  - Cross-cutting platform work has to be filed under `platform/` in docs, which is a soft catch-all — discipline is required to keep it from becoming a junk drawer.
  - Components that genuinely span roles (a CLI that is also a service) need a judgment call; the role READMEs document the tiebreaker but cannot eliminate the ambiguity.
  - Renaming a scope (a service rename) requires moving both code under `<role>/<name>/` and docs under `docs/{specs,plans,adr}/<name>/` in lockstep; tooling does not yet enforce this.
- **Follow-ups:**
  - Per-role conventions (naming, ports, env, language choices when they crystallize) live in each role directory's `README.md`; keep them there, not in this ADR.
  - If a fifth top-level role emerges (e.g. `infra/` for IaC, `runbooks/` for ops), file a successor ADR rather than quietly adding the directory.
  - Revisit if the flat `<type>/<scope>/` doc tree starts collapsing under its own weight — at that point a successor ADR introduces sub-grouping, rather than this one being edited.
