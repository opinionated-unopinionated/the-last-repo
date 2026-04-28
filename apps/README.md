# apps/

User-facing applications: web frontends, mobile clients, desktop apps, CLIs that ship to humans. Backend HTTP/RPC services live under `services/`; reusable libraries live under `packages/`.

## Layout

```
apps/
└── <app-name>/        # one directory per app, kebab-case
    ├── README.md      # what the app does, how to run it
    └── ...            # language/framework of the app's choice
```

One directory per app. Polyglot is allowed — each app picks its own stack.

## Naming convention

- Directory name is **kebab-case** and is the **canonical app identifier**.
- The same name is reused as the **doc scope**: specs, plans, and ADRs scoped to this app live under `docs/{specs,plans,adr}/<app-name>/`.
- The same name is reused as the env-var prefix (uppercased, `-` → `_`): app `web-console` → `WEB_CONSOLE_*`.

Pick the name once, reuse everywhere. Do not introduce parallel synonyms.

## Port conventions (local dev)

To avoid collisions when running multiple apps side by side, the first app added picks a port in the **3000–3999** range (frontends) or **4000–4999** range (CLIs/desktop with a local server). New apps increment by 10. Record the chosen port in the app's own `README.md` and in any spec/ADR that describes its public surface.

| Range     | Use                          |
| --------- | ---------------------------- |
| 3000-3999 | Web/mobile frontends (dev)   |
| 4000-4999 | Desktop or CLI dev servers   |
| 5000+     | Reserved for `services/`     |

## Env conventions

- Local-dev defaults live in `apps/<app-name>/.env.example`. Real secrets never enter the repo.
- Every env var an app reads is **prefixed with the app's identifier** (e.g. `WEB_CONSOLE_API_BASE_URL`). Shared platform vars (e.g. `NODE_ENV`) are the only exception.
- Env vars consumed at build time vs. runtime must be distinguished in the app's README.

## Adding a new app

1. `make new-spec NAME=<app-name>/<slug>` to capture intent.
2. `make new-plan NAME=<app-name>/<slug>` for the executable checklist.
3. Create `apps/<app-name>/` with at minimum a `README.md` describing run/build/test commands.
4. If the choice is architecturally load-bearing (framework, runtime, deployment target), file an ADR under `docs/adr/<app-name>/`.
