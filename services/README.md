# services/

Backend HTTP/RPC services: APIs, workers, schedulers, daemons — anything that runs on a server and is consumed by other software (or by an `apps/` frontend), not directly by humans. User-facing applications live under `apps/`; reusable libraries live under `packages/`.

## Layout

```
services/
└── <service-name>/     # one directory per service, kebab-case
    ├── README.md       # what the service does, how to run it
    └── ...             # language/framework of the service's choice
```

One directory per service. Polyglot is allowed — each service picks its own stack.

## Naming convention

- Directory name is **kebab-case** and is the **canonical service identifier**.
- The same name is reused as the **doc scope**: specs, plans, and ADRs scoped to this service live under `docs/{specs,plans,adr}/<service-name>/`.
- The same name is reused as the env-var prefix (uppercased, `-` → `_`): service `auth-api` → `AUTH_API_*`.

Pick the name once, reuse everywhere. Do not introduce parallel synonyms.

## Port conventions (local dev)

To avoid collisions when running multiple services side by side, services occupy the **5000+** range. The first service added picks a port at 5000; new services increment by 10. Record the chosen port in the service's own `README.md` and in any spec/ADR that describes its public surface.

| Range     | Use                          |
| --------- | ---------------------------- |
| 3000-3999 | Reserved for `apps/` (web)   |
| 4000-4999 | Reserved for `apps/` (CLI)   |
| 5000-5999 | Backend services (dev)       |
| 6000+     | Workers, schedulers, daemons |

## Env conventions

- Local-dev defaults live in `services/<service-name>/.env.example`. Real secrets never enter the repo; production secrets are injected by the deployment environment.
- Every env var a service reads is **prefixed with the service's identifier** (e.g. `AUTH_API_DATABASE_URL`). Shared platform vars (e.g. `LOG_LEVEL`) are the only exception.
- Document required vs. optional vars in the service's README, and note which are needed at build time vs. runtime.

## Public surface

A service's public surface — HTTP routes, RPC methods, queue topics, event schemas — must be documented in the service's `README.md` or in a linked spec under `docs/specs/<service-name>/`. Breaking changes to the public surface require a spec update and, if architecturally load-bearing, an ADR.

## Adding a new service

1. `make new-spec NAME=<service-name>/<slug>` to capture intent.
2. `make new-plan NAME=<service-name>/<slug>` for the executable checklist.
3. Create `services/<service-name>/` with at minimum a `README.md` describing run/build/test commands and the chosen dev port.
4. If the choice is architecturally load-bearing (runtime, datastore, deployment target, transport), file an ADR under `docs/adr/<service-name>/`.
