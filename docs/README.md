# `docs/` — Documentation map

This is the documentation root for The Last Repo. Three top-level types live here, each with its own scoped subtree. Load only what the current task needs; do not pre-read the whole tree.

## Types

| Folder | Purpose | When to write one |
| --- | --- | --- |
| [`specs/`](./specs/) | Product/feature intent. **What and why.** | A new feature, behavior change, or product decision needs to be described before it is built. |
| [`plans/`](./plans/) | Executable checklists. **How and in what order.** | Work needs to be broken into tasks the Ralph loop can iterate over. Every plan has a §6 Checklist and §7 Loop Recipe. |
| [`adr/`](./adr/) | Architectural decisions, Nygard-style. | A decision constrains future code (tech choice, layout, policy). Captured once, immutable thereafter (status: superseded if revisited). |

## Layout

Each type uses a flat, scoped tree:

```
docs/<type>/
├── README.md          # conventions for this type
├── TEMPLATE.md        # canonical template; copy via scripts/new-<type>.sh
└── <scope>/           # platform/, <service-name>/, <app-name>/, …
    └── NNNN-<slug>.md # zero-padded sequence per scope
```

Scopes are flat — do not nest. Common scopes:

- `platform/` — repo-wide concerns (CI, monorepo layout, AI harness, conventions).
- `<service-name>/` — one per backend service in `services/`.
- `<app-name>/` — one per frontend app in `apps/`.
- `<package-name>/` — one per shared library in `packages/` when it warrants its own docs.

Numbering is per-scope: `docs/plans/platform/0001-…` and `docs/plans/billing/0001-…` coexist.

## Authoring

Use the generators; they copy the matching template and reserve the next number in the chosen scope:

```bash
make new-spec NAME=<scope>/<slug>
make new-plan NAME=<scope>/<slug>
make new-adr  NAME=<scope>/<slug>
```

Templates (`TEMPLATE.md` in each subfolder) are loaded only when authoring a new doc of that type. Do not pre-read them otherwise.

## Reading order for agents

Per `AGENTS.md`, progressive disclosure applies:

1. `AGENTS.md` (root) — entry point.
2. This file — the map.
3. The relevant scoped folder for the current task.
4. The matching `TEMPLATE.md` only when authoring a new doc.

Stop when you have what you need. Do not read sibling scopes "just in case".
