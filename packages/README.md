# packages/

Shared libraries: code consumed by `apps/`, `services/`, or other packages — never run on its own. User-facing applications live under `apps/`; backend HTTP/RPC services live under `services/`; local dev-only tooling lives under `tools/`.

## Layout

```
packages/
└── <package-name>/      # one directory per package, kebab-case
    ├── README.md        # what the package exports, how to consume it
    └── ...              # language/framework of the package's choice
```

One directory per package. Polyglot is allowed — each package picks its own language. Cross-language packages (e.g. a schema definition consumed by both a TypeScript app and a Go service) are explicitly supported: keep generated bindings inside the package directory and document the regeneration command in its README.

## Naming convention

- Directory name is **kebab-case** and is the **canonical package identifier**.
- The same name is reused as the **doc scope**: specs, plans, and ADRs scoped to this package live under `docs/{specs,plans,adr}/<package-name>/`.
- When a package publishes to a language registry (npm, PyPI, crates.io, Go module path), the published name should match the directory name; namespace prefixes (e.g. `@org/<package-name>`) are allowed when the registry requires them.

Pick the name once, reuse everywhere. Do not introduce parallel synonyms.

## Consumers and contracts

A package's **public API** — exported symbols, types, schemas, CLI surface — is its contract with consumers in `apps/`, `services/`, and other packages. Document it in the package's `README.md` or in a linked spec under `docs/specs/<package-name>/`.

- **Breaking changes** to the public API require a spec update and, if architecturally load-bearing, an ADR. Bump the package version (semver) when you ship the change.
- **Cross-cutting changes** that touch a package and its consumers in the same PR must list every consumer in the PR description so reviewers can audit blast radius.
- Packages must not depend on `apps/` or `services/`. Dependencies between packages are allowed but should be acyclic.

## Adding a new package

1. `make new-spec NAME=<package-name>/<slug>` to capture intent (what the package exports and why it exists as a shared library rather than living inside one consumer).
2. `make new-plan NAME=<package-name>/<slug>` for the executable checklist.
3. Create `packages/<package-name>/` with at minimum a `README.md` describing the public API, install/import instructions, and test command.
4. If the choice is architecturally load-bearing (language, runtime requirement, distribution mechanism), file an ADR under `docs/adr/<package-name>/`.
