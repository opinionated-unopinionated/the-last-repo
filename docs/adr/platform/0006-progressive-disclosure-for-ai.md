---
id: 0006-progressive-disclosure-for-ai
title: Progressive disclosure as the AI context strategy
status: accepted
scope: platform
date: 2026-04-27
supersedes:
superseded_by:
---

# Progressive disclosure as the AI context strategy

## Context

Every AI harness this repo supports (`pi`, `claude`, `codex`) operates with a finite context window and pays — in latency, cost, and reasoning quality — for every token it loads before it starts the actual task. The repo's documentation footprint is designed to grow: specs, plans, and ADRs accumulate per scope, and the role-based code shells (locked decision #2 in plan `0001-bootstrap-the-last-repo` §3, ratified in ADR `0002-monorepo-layout`) invite per-component READMEs alongside them. A scaffold that does not give agents an explicit answer to *what to read first, and what to defer* will, by default, encourage them to either pull everything (drowning the task in irrelevant context) or pull nothing (hallucinating conventions the repo already documents).

The forces in play:

- **Context-window economics.** Bulk-loading docs upfront leaves less budget for the file the agent is actually editing and the reasoning trace it has to produce. Agents that read selectively from a known map outperform agents that pre-load a wall of text on the same task.
- **Single-source-of-truth contract.** Locked decision #5 (ADR `0005-ralph-loop-mandate` §Decision point 2) makes `AGENTS.md` the canonical agent context across all harnesses. If `AGENTS.md` becomes the dumping ground for every convention, the contract file itself becomes the bottleneck the strategy was meant to avoid.
- **Polyglot scope (decision #1) and flat doc tree (decision #8).** The repo will accumulate `<type>/<scope>/` folders that are mostly irrelevant to any given task. The reading strategy has to make scope-locality cheap — an agent working in `services/billing/` should not pay for `services/auth/` context.
- **Harness-agnosticism.** The strategy cannot rely on a feature only one harness offers (e.g. retrieval plugins, vector indexes, MCP servers). It has to work in `pi`, `claude`, and `codex` with no extra infrastructure, which means it must live in the file layout itself.

The alternatives considered:

- **Monolithic `AGENTS.md` containing every convention.** One file the agent reads, no further lookups needed. Simple, but it grows without bound, becomes the largest file in the repo, and re-introduces the very context-bloat problem the file is meant to prevent. It also conflates orientation (stable, short) with reference material (volatile, long).
- **No entry point; agent crawls the repo.** Cheapest authoring cost. In practice the agent either crawls breadth-first and burns context on irrelevant files, or guesses at structure and contradicts existing conventions. Observed across all three harnesses on the bootstrap plan's early iterations.
- **Retrieval-augmented context (vector store, MCP server, embedded search).** Powerful but harness-specific, infrastructure-heavy, and out of step with locked decision #3 (`git clone`-only bootstrap). It also hides the structure from human readers, who benefit from the same map agents use.
- **Layered entry point with explicit reading order and a hard size cap on the entry file.** A short `AGENTS.md` orients the agent and points at a small set of next-hop documents (`docs/README.md`, then a scoped folder, then a template). Each layer is small, named, and loaded only when the task requires it. Mirrors how a new human contributor would read the repo, and works identically across harnesses because it is purely a file-layout convention.

The decision is needed *now* because `AGENTS.md` (`t1.03`) is already in place with a 100-line cap, `docs/README.md` (`t3.01`) and the per-type READMEs (`t3.02`, `t3.05`, `t3.07`) have just landed, and Phase 4–6 work (Make targets, CI guards, generators) will start adding more documents the strategy has to absorb without forcing them all into `AGENTS.md`.

## Decision

The repo organizes AI context as a layered, lazily-loaded reading path with an explicit order and a hard size cap on the entry file: (1) `AGENTS.md` at the root (≤100 lines, orientation and pointers only); (2) `docs/README.md` (map of `specs/`, `plans/`, `adr/`); (3) the relevant scoped folder `docs/<type>/<scope>/` (loaded only when working in that area); (4) `docs/<type>/TEMPLATE.md` (loaded only when authoring a new doc of that type) — and `AGENTS.md` is the single canonical entry point that every harness reads (with `CLAUDE.md` symlinked to it per ADR `0005` decision point 2).

## Consequences

- **Positive:**
  - The agent's first read is bounded and predictable: under 100 lines of `AGENTS.md` is enough to orient on any task in the repo, regardless of how large the documentation tree grows.
  - Scope-locality is preserved by construction — an agent working in `services/billing/` loads `docs/{specs,plans,adr}/billing/` and ignores other scopes, which keeps context proportional to the task instead of to the repo size.
  - The strategy is purely file-layout; it works identically in `pi`, `claude`, and `codex` with no extra infrastructure, honoring locked decision #3 (`git clone`-only bootstrap) and decision #5 (`AGENTS.md` as the single source of truth).
  - The same path serves human contributors: a new maintainer reads `AGENTS.md` first, then the scoped doc folder, then templates if authoring — no separate "human onboarding" doc to drift from the agent contract.
  - `AGENTS.md` stays a contract, not a reference manual: when a new convention emerges, it lives in the relevant `docs/<type>/README.md` or its own ADR, and `AGENTS.md` only links to it. The contract file is shielded from growth pressure.
- **Negative:**
  - The 100-line cap on `AGENTS.md` is a constraint that will be tested on every change to the contract; reviewers must reject growth that should have been pushed down into a `docs/<type>/README.md` or an ADR.
  - Lazy loading depends on the agent honoring the reading order — a harness that ignores `AGENTS.md` and pulls everything will still bloat its context, and the strategy has no way to prevent that beyond making the entry file the cheapest path to take.
  - Scope-locality assumes contributors keep cross-scope rules out of scoped folders; a `services/billing/` doc that secretly documents a platform-wide convention will mislead agents working in other scopes. Discipline is required, especially in `platform/`, which is the soft catch-all called out in ADR `0002-monorepo-layout` §Consequences.
  - Splitting orientation (in `AGENTS.md`) from reference (in `docs/<type>/README.md` and ADRs) means a contributor adding a new convention has to make a placement call. The per-type READMEs and this ADR are the tiebreakers, but ambiguity at the margin is real.
- **Follow-ups:**
  - Keep `AGENTS.md` under the 100-line cap on every edit; if the entry file grows past it, the fix is to move detail into a `docs/<type>/README.md` or a new ADR and link to it, not to relax the cap.
  - When a new top-level convention is added (e.g. a `docs/runbooks/` folder per the open question in plan `0001-bootstrap-the-last-repo` §9), update the `docs/README.md` map and add a one-line pointer in `AGENTS.md` — never inline the convention itself.
  - `make lint-docs` (`t5.01`) is the natural place to enforce the line cap on `AGENTS.md` mechanically; the linter, not this ADR, owns that check.
  - If a future harness offers a retrieval mechanism that genuinely outperforms the file-layout strategy (e.g. a repo-wide MCP server every harness can speak), file a successor ADR rather than editing this one.
