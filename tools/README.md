# tools/

Local tooling: generators, codegen, dev-only utilities, and scripts that help contributors work in this repo but are **never shipped to users or run in production**. User-facing applications live under `apps/`; backend HTTP/RPC services live under `services/`; reusable libraries that ship to consumers live under `packages/`. Repository-wide shell scripts that drive the loop and the Make targets live under `scripts/` — `tools/` is for richer, longer-lived utilities, not one-shot shell glue.

## Layout

```
tools/
└── <tool-name>/        # one directory per tool, kebab-case
    ├── README.md       # what the tool does, how to invoke it
    └── ...             # language/framework of the tool's choice
```

One directory per tool. Polyglot is allowed — each tool picks its own stack. A tool may be a single script, a small CLI, a code generator, a fixture builder, a migration helper, or any other utility that exists to make the repo easier to work in.

## `tools/` vs `scripts/`

| Location   | When to put code here                                                                              |
| ---------- | -------------------------------------------------------------------------------------------------- |
| `scripts/` | Short shell scripts wired into `make` targets or the Ralph loop (`ralph.sh`, `new-*.sh`, harness). |
| `tools/`   | Anything larger, anything written in a non-shell language, anything with its own dependencies.     |

If a script grows beyond ~50 lines, gains dependencies, or needs tests, promote it to its own directory under `tools/`.

## Naming convention

- Directory name is **kebab-case** and is the **canonical tool identifier**.
- The same name is reused as the **doc scope**: specs, plans, and ADRs scoped to this tool live under `docs/{specs,plans,adr}/<tool-name>/`.

Pick the name once, reuse everywhere. Do not introduce parallel synonyms.

## Constraints

- Tools must not be imported by `apps/`, `services/`, or `packages/`. If consumer code needs the functionality, it belongs in `packages/`, not `tools/`.
- Tools may depend on `packages/` (e.g. a generator that reads a schema package).
- Tools should be invokable from the repo root via a single command, documented in their `README.md`. Wire frequently used tools into `Makefile` targets so contributors do not need to memorise invocations.
- No production secrets. Tools that need credentials read them from the environment and document the required vars in their `README.md`.

## Adding a new tool

1. `make new-spec NAME=<tool-name>/<slug>` if the tool is non-trivial or its behaviour needs to be agreed before building.
2. `make new-plan NAME=<tool-name>/<slug>` for the executable checklist (only required if the work is large enough to warrant a Ralph loop).
3. Create `tools/<tool-name>/` with at minimum a `README.md` describing what it does, how to invoke it, and any required env vars.
4. If the choice is architecturally load-bearing (language, distribution, runtime requirement), file an ADR under `docs/adr/<tool-name>/`.
