# Contributing to The Last Repo

Thanks for considering a contribution. The Last Repo is an opinionated scaffold, and most of its opinions are about *how work happens*. Read this file before opening a PR — it will save us both a round trip.

## TL;DR

1. Non-trivial work is driven by a **Ralph loop**, not by ad-hoc sessions.
2. Non-trivial PRs must reference a **spec** (`docs/specs/`) and/or **plan** (`docs/plans/`).
3. PRs that touch `docs/plans/**` or `docs/specs/**` must include the trailer `Ralph-Run: <plan-id>` (or have an entry in `.ralph/logs/`). CI enforces this.

## The Ralph loop is the default workflow

Non-trivial changes are executed through a [Ralph Wiggum loop](https://ghuntley.com/ralph/): a plan defines the work as a checklist, and a coding-agent harness iterates over it one task at a time with fresh context. See `AGENTS.md` for the contract and `docs/plans/platform/0001-bootstrap-the-last-repo.md` for the canonical example.

To drive a loop:

```bash
# Default harness: pi (npm i -g @mariozechner/pi-coding-agent)
# Or: AI_HARNESS=claude  |  AI_HARNESS=codex
bash scripts/ralph.sh
# or
make ralph
```

You can absolutely contribute without running the loop yourself — but the resulting PR still needs to look like loop output: small, single-purpose, with a referenced plan or spec for anything beyond a typo or trivial fix.

## What counts as "non-trivial"?

A change is **trivial** (no spec/plan required) if it is one of:

- Typo, formatting, or comment fix.
- Dependency bump with no behavior change.
- Lint/CI tweak that doesn't change repo conventions.

Everything else is **non-trivial** and needs a spec, a plan, or both:

- New feature, app, service, or package → start with a **spec** (`make new-spec NAME=<scope>/<slug>`).
- Multi-step implementation work → write a **plan** (`make new-plan NAME=<scope>/<slug>`) with a §6 Checklist and §7 Loop Recipe.
- Architectural decision → record it as an **ADR** (`make new-adr NAME=<scope>/<slug>`).

If in doubt, open an issue first and ask. Cheap to ask, expensive to undo.

## Commit conventions

- Use [Conventional Commits](https://www.conventionalcommits.org/) prefixes: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `ci:`.
- Keep subjects under 72 characters.
- For any change touching `docs/plans/**` or `docs/specs/**`, add the trailer:

  ```
  Ralph-Run: <plan-id>
  ```

  where `<plan-id>` is the frontmatter `id` of the plan that authorized the change (e.g. `0001-bootstrap-the-last-repo`). PRs without this trailer **and** without a corresponding `.ralph/logs/` entry will fail CI.

## PR checklist

Before requesting review, confirm:

- [ ] Linked spec under `docs/specs/<scope>/` (if applicable).
- [ ] Linked plan under `docs/plans/<scope>/` (if applicable).
- [ ] ADR added under `docs/adr/<scope>/` if the change reflects an architectural decision.
- [ ] `Ralph-Run: <plan-id>` trailer present for plan/spec changes (or `.ralph/logs/` entry).
- [ ] `make lint-docs` passes.
- [ ] PR is single-purpose. Drive-by fixes belong in a separate PR.

## Code of Conduct

Participation in this project is governed by [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md). By contributing, you agree to uphold it.

## License

By contributing, you agree your contributions are licensed under the MIT License — see [`LICENSE`](LICENSE).
