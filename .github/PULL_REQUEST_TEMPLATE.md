<!--
Thanks for contributing to The Last Repo. Read `CONTRIBUTING.md` if you have not
already — it explains the Ralph-loop workflow that this template assumes.

Keep PRs single-purpose. Drive-by fixes belong in a separate PR. Non-trivial
work should be authorized by a spec and/or a plan; PRs touching `docs/plans/**`
or `docs/specs/**` must carry a `Ralph-Run: <plan-id>` trailer or a matching
`.ralph/logs/` entry, or CI will fail.
-->

## Summary

<!-- One or two sentences: what does this PR change, and why? -->

## Linked work

<!-- Fill in the references that apply. Use repo-relative paths so reviewers can
click through. Use "n/a" for items that do not apply to this PR. -->

- Spec: <!-- e.g. `docs/specs/<scope>/<NNNN>-<slug>.md` or n/a -->
- Plan: <!-- e.g. `docs/plans/<scope>/<NNNN>-<slug>.md` or n/a -->
- ADR(s): <!-- e.g. `docs/adr/<scope>/<NNNN>-<slug>.md` or n/a -->
- Ralph run: <!-- `.ralph/logs/<file>` line(s) or `Ralph-Run: <plan-id>` trailer, or n/a -->
- Related issues: <!-- e.g. `Closes #123`, `Refs #456`, or n/a -->

## Scope of change

- Scope (folder under `apps/`, `services/`, `packages/`, `tools/`, or `platform`):
- Surface area touched (config, scripts, docs, code, CI):
- Breaking change? (yes / no):
- Single-purpose? (yes / no — if no, justify):

## Checklist

- [ ] Linked spec under `docs/specs/<scope>/` (if the change implements user-visible intent).
- [ ] Linked plan under `docs/plans/<scope>/` (if the change is multi-step or non-trivial).
- [ ] ADR added under `docs/adr/<scope>/` if the change reflects an architectural decision.
- [ ] `Ralph-Run: <plan-id>` trailer present **or** a `.ralph/logs/` entry exists for plan/spec changes.
- [ ] `make lint-docs` passes locally.
- [ ] PR is single-purpose; no drive-by fixes bundled in.
- [ ] Conventional Commits prefix used in the title (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `ci:`).

## Testing

<!-- How did you verify the change? Commands run, manual checks, screenshots,
log excerpts. For Ralph-driven work, link the relevant `.ralph/logs/` lines. -->

## Notes for reviewers

<!-- Anything reviewers should pay extra attention to: risky areas, follow-ups
intentionally deferred to another plan, open questions left in the linked plan's
§9, etc. -->
