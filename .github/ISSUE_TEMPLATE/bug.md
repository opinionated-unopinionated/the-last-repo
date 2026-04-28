---
name: Bug report
about: Report unexpected behavior, a regression, or a defect in The Last Repo scaffold.
title: "bug: <short summary>"
labels: ["bug", "triage"]
assignees: []
---

<!--
Before filing: search existing issues and check `docs/plans/` and `docs/adr/` for
known work that may already address this. If the bug is in a specific service or
app, mention its scope (e.g. `platform`, `<service-name>`, `<app-name>`).
-->

## Summary

<!-- One sentence: what is broken? -->

## Environment

- OS / arch:
- Shell:
- Make version (`make --version`):
- AI harness (`pi` / `claude` / `codex`) and version, if relevant:
- Commit SHA (`git rev-parse HEAD`):

## Steps to reproduce

1.
2.
3.

## Expected behavior

<!-- What did you expect to happen? -->

## Actual behavior

<!-- What actually happened? Include full error output, stack traces, or log
excerpts. For Ralph loop issues, attach the relevant `.ralph/logs/last.log`
lines. -->

```
<paste logs / output here>
```

## Scope and impact

- Scope (folder under `apps/`, `services/`, `packages/`, `tools/`, or `platform`):
- Blocks the Ralph loop? (yes / no):
- Workaround, if any:

## Additional context

<!-- Links to related specs, plans, ADRs, or upstream issues. -->
