---
id: 0001-record-architecture-decisions
title: Record architecture decisions
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Record architecture decisions

## Context

The Last Repo is an opinionated, AI-first, polyglot monorepo scaffold. Its value comes from a small set of deliberate constraints — Make as orchestrator, Ralph loops as the contract, `AGENTS.md` as canonical AI context, progressive disclosure as the reading rule — and those constraints will outlive the conversations and PRs that produced them. Without a durable record, the *why* behind each rule decays into folklore: future contributors (human and agent) re-litigate settled questions, or quietly drift away from constraints whose rationale they cannot reconstruct.

Several mechanisms were on the table: long-form prose in `README.md`, a single `DECISIONS.md` ledger, comments at the point of constraint, or per-decision files. Prose and ledgers grow unwieldy and lose status tracking; comments scatter rationale across the tree and rot under refactors. A per-decision, status-tracked, immutable-in-intent format — Michael Nygard's ADR — solves all three: each decision is one short file, the status field captures lifecycle, and immutability means superseded decisions remain readable as history rather than being rewritten out of existence.

The decision is needed *now* because subsequent ADRs in this scope (`0002` monorepo layout, `0003` Make as orchestrator, `0004` pi as default harness, `0005` Ralph-loop mandate, `0006` progressive disclosure) presume the format and location this ADR establishes.

## Decision

We will record architecturally significant decisions as Architecture Decision Records (ADRs) under `docs/adr/<scope>/<NNNN>-<slug>.md`, in the Nygard format (Context / Decision / Consequences), with status tracked in frontmatter and one decision per file.

## Consequences

- **Positive:**
  - The reasoning behind every binding constraint is discoverable from the repo alone — no chat-log archaeology.
  - New contributors and AI agents can scan `docs/adr/<scope>/` for accepted decisions before proposing changes, per the progressive-disclosure reading order in `AGENTS.md`.
  - Superseding a decision is a first-class operation (`supersedes:` / `superseded_by:` cross-links) instead of a silent rewrite, so the historical record stays intact.
  - Specs and plans gain a stable place to cite the constraints they live under.
- **Negative:**
  - Every architectural choice now has an authoring cost. Trivial or reversible choices that get written up as ADRs add noise; `docs/adr/README.md` defines the "when to write one" filter to limit this.
  - The discipline only works if it is honored. ADRs that go unwritten or get edited after acceptance silently erode the value of the practice.
  - Scoped numbering (`NNNN` per scope) requires a generator (`scripts/new-adr.sh`) to avoid collisions; manual creation invites duplicate IDs.
- **Follow-ups:**
  - Author the remaining platform ADRs queued in plan `0001-bootstrap-the-last-repo` §6 Phase 3 (`0002`–`0006`).
  - Ensure `scripts/new-adr.sh` (Phase 4, t4.05) picks the next `NNNN` per scope and copies `docs/adr/TEMPLATE.md`.
  - Reference this ADR from `docs/adr/README.md` and from `AGENTS.md` if and when an explicit pointer is needed; for now the README already documents the format.
