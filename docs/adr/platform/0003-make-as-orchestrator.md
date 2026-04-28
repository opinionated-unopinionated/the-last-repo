---
id: 0003-make-as-orchestrator
title: Make as orchestrator
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Make as orchestrator

## Context

The Last Repo is a polyglot scaffold meant to be cloned and used by teams whose stacks we cannot predict. Whatever runs the repo's top-level commands — start the Ralph loop, scaffold a new spec/plan/ADR, lint docs, run CI locally — must satisfy three constraints that fall out of decisions already locked in plan `0001-bootstrap-the-last-repo` §3:

- **Zero install for setup.** Locked decision #3 says the repo bootstraps via `git clone`, with no installer step. Anything the orchestrator depends on either ships with the OS or it is not the orchestrator.
- **Language-agnostic.** Locked decision #1 keeps the role-based shells empty; the orchestrator cannot privilege Node, Go, Python, or any other ecosystem.
- **Harness-agnostic.** Locked decision #5 keeps `AGENTS.md` as the single source of truth for the AI harness; the same constraint applies to the build entry point — a contributor working with `pi`, `claude`, or `codex` must hit the same commands.

The alternatives on the table all failed at least one constraint:

- **Bazel / Buck / Pants.** Powerful for very large polyglot codebases but heavyweight to install, intrusive on directory layout, and overkill for a scaffold whose role-based shells start empty.
- **Nx, Turborepo, Lerna.** Strong polyglot orchestration but require a Node toolchain at the root, violating the zero-install bootstrap.
- **Just, Task (go-task), mise tasks.** Lightweight and pleasant, but each requires a separate install step before the first command works.
- **npm scripts.** Same Node-toolchain problem as Nx/Turbo, and forces a `package.json` at the root that misrepresents the repo as a Node project.
- **Plain shell scripts with no orchestrator.** Solves the install problem but loses self-documenting `make help`, target composition, and the conventional `make X` muscle memory contributors already have.

GNU Make is preinstalled on macOS and every mainstream Linux distribution (and trivially available on Windows via WSL or Git Bash), it imposes no directory layout, it has no opinion about what runs inside its targets, and `make help` is a well-worn pattern for self-describing target lists. It loses on incremental-build sophistication and modern UX, but those are not what this layer is being asked to do — per-language build tools handle their own incremental builds behind whatever Make target invokes them. The decision is needed *now* because Phase 5 of the bootstrap plan (`t5.01`) creates the `Makefile` as the canonical entry point that `AGENTS.md`, `README.md`, `CONTRIBUTING.md`, and the per-role READMEs already reference.

## Decision

The repo uses plain GNU Make as its top-level command orchestrator: a single root `Makefile` exposes the user-facing entry points (`help`, `ralph`, `new-spec`, `new-plan`, `new-adr`, `lint-docs`, `ci`, …) and delegates the actual work to per-language tools and the scripts under `scripts/`.

## Consequences

- **Positive:**
  - The repo is usable immediately after `git clone` with no orchestrator install — Make is already on every supported developer machine.
  - Contributors and AI agents have one well-known command surface (`make <target>`) regardless of which languages a given component uses, satisfying the harness- and language-agnostic constraints.
  - `make help` is the canonical "what can I do here?" entry point, and AGENTS.md / READMEs can point to it without prescribing a language ecosystem.
  - Per-language tooling (npm, cargo, go, uv, etc.) stays where it belongs — inside the component that needs it — and is wrapped, not replaced, by Make targets when the repo wants a uniform invocation.
  - Migrating to a more sophisticated orchestrator later (Bazel, Nx, Just) is a strict superset move: a successor ADR can introduce it while keeping `make` as a thin shim for backwards compatibility.
- **Negative:**
  - Makefile syntax is dated — tab-indented recipes, idiosyncratic variable expansion, sharp edges around `.PHONY` and pattern rules — and it will trip up contributors who have never written one.
  - Make has no native task caching, no remote execution, and only crude parallelism (`-j`); the repo gets none of the build-graph wins that Bazel-class tools provide.
  - Composition across many components scales awkwardly: as the repo grows, target names become noisy (`make build-services-billing`) unless conventions stay disciplined.
  - The orchestrator is invisible to per-language tooling — `npm run`, `cargo`, `go test` run independently and will not respect Make-level dependencies unless authors wire them in explicitly.
- **Follow-ups:**
  - The `Makefile` created in plan `0001-bootstrap-the-last-repo` §6 Phase 5 (`t5.01`) is the single source of truth for top-level targets; document new targets there with a `## help` comment so `make help` picks them up automatically.
  - Per-component build/test commands live in each component's own README and tooling; do not push them into the root `Makefile` unless a contributor would reasonably expect to invoke them from the repo root.
  - If the repo outgrows Make — measured in target sprawl, missing caching, or contributor friction — file a successor ADR introducing a richer orchestrator rather than editing this one.
