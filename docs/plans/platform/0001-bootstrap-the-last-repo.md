---
id: 0001-bootstrap-the-last-repo
title: Bootstrap "The Last Repo" scaffold
status: in-progress
scope: platform
owner: TBD
created: 2026-04-27
updated: 2026-04-27
loop_driver: scripts/ralph.sh
loop_prompt: PROMPT.md
---

# Bootstrap "The Last Repo" scaffold

## 1. Goal

The Last Repo is an opinionated, AI-first, polyglot monorepo scaffold the open-source community can clone and extend. This plan generates the initial repository contents, end-to-end, via a Ralph Wiggum loop driven by `scripts/ralph.sh` and the canonical prompt at `PROMPT.md`.

## 2. Why a self-bootstrapping plan

In the spirit of the repo, the scaffold is built by the same loop it teaches. This plan IS the input to the loop. Each iteration picks one unchecked task, performs it, checks it off, and exits. Successive iterations build up the full scaffold from a cold start. This file is the proof that the loop works on day one.

## 3. Locked decisions

| #  | Topic               | Choice                                                              | Rationale                                                                                  |
| -- | ------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| 1  | Polyglot scope      | Empty language-agnostic shells                                      | Standard Go layout philosophy: structure without prescribing language                      |
| 2  | Build orchestrator  | Plain Make                                                          | Universally available, zero install, minimal opinion                                       |
| 3  | Bootstrap mode      | `git clone` (no installer)                                          | Lowest friction; no Node dependency for setup                                              |
| 4  | Ralph enforcement   | All four: `ralph.sh` + AGENTS.md mandate + plan template + CI guard | Loops are the contract, not a suggestion                                                   |
| 5  | Harness selection   | `AGENTS.md` canonical + symlinks                                    | One source of truth; `CLAUDE.md` symlinks to `AGENTS.md`; Codex reads `AGENTS.md` natively |
| 6  | Default AI harness  | `@mariozechner/pi-coding-agent`                                     | User preference; loop driver supports `pi`, `claude`, `codex`                              |
| 7  | CI provider         | GitHub Actions only                                                 | Cover the majority case; document portability                                              |
| 8  | Doc layout          | `docs/{specs,plans,adr}/<scope>/` flat tree                         | Easy to grep; scales to many services without nesting                                      |
| 9  | License             | MIT                                                                 | Maximally permissive for an OSS template                                                   |

## 4. Final repo layout (target)

```
the-last-repo/
├── .editorconfig
├── .gitattributes
├── .gitignore
├── .github/
│   ├── ISSUE_TEMPLATE/{bug,feature,spec}.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/{ci,ralph-guard}.yml
├── AGENTS.md                    # canonical AI context (entry point)
├── CLAUDE.md                    # symlink → AGENTS.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── Makefile
├── PROMPT.md                    # default Ralph loop prompt
├── README.md
├── SECURITY.md
├── apps/
│   └── README.md                # frontend conventions
├── docs/
│   ├── README.md                # documentation map
│   ├── adr/
│   │   ├── README.md
│   │   ├── TEMPLATE.md
│   │   └── platform/0001..0006-*.md
│   ├── plans/
│   │   ├── README.md
│   │   ├── TEMPLATE.md
│   │   └── platform/0001-bootstrap-the-last-repo.md   ← this file
│   └── specs/
│       ├── README.md
│       ├── TEMPLATE.md
│       └── platform/.gitkeep
├── packages/
│   └── README.md                # shared libraries
├── scripts/
│   ├── harness.sh               # dispatch to chosen harness
│   ├── new-adr.sh
│   ├── new-plan.sh
│   ├── new-spec.sh
│   └── ralph.sh                 # loop driver
├── services/
│   └── README.md                # backend conventions
└── tools/
    └── README.md                # local tooling
```

## 5. Progressive-disclosure entry path

Every harness should encounter the same reading order, smallest-first:

1. `AGENTS.md` (root) — the entry point. Short. Orients the agent and points to deeper context.
2. `docs/README.md` — a map of `specs/`, `plans/`, `adr/`.
3. The relevant scoped folder (`docs/<type>/<scope>/`) — fetched only when working in that area.
4. Templates (`docs/<type>/TEMPLATE.md`) — loaded only when authoring a new doc of that type.

`AGENTS.md` is the contract; everything else is discovered as needed. Keep `AGENTS.md` under ~100 lines.

## 6. Checklist (Ralph iterates here)

> One iteration = one checkbox. Pick the first unchecked item. Do only that. Check it off. Exit. The driver re-invokes with fresh context.

### Phase 1 — Project meta
- [ ] **t1.01** Create `LICENSE` (MIT 2026, "The Last Repo contributors")
- [ ] **t1.02** Create root `README.md`: project pitch, decisions table linking this plan, quickstart, contributing pointer
- [ ] **t1.03** Create `AGENTS.md`: progressive-disclosure entry. Lists key paths, reading order, Ralph-loop mandate, harness compatibility note. Hard cap: 100 lines
- [ ] **t1.04** Symlink `CLAUDE.md → AGENTS.md` (`ln -s AGENTS.md CLAUDE.md`)
- [ ] **t1.05** Create `CONTRIBUTING.md`: Ralph loop is the default workflow; spec/plan templates required for non-trivial PRs; commit trailer `Ralph-Run: <plan-id>` for plan/spec changes
- [ ] **t1.06** Create `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1)
- [ ] **t1.07** Create `SECURITY.md` (responsible disclosure stub)
- [ ] **t1.08** Create `.editorconfig` (LF, utf-8, 2-space indent default, language overrides minimal)
- [ ] **t1.09** Create `.gitignore` (polyglot: node, python, go, rust, java, .DS_Store, IDE files, `.ralph/logs/`)
- [ ] **t1.10** Create `.gitattributes` (LF normalization, common binary markers)

### Phase 2 — Monorepo shells
- [ ] **t2.01** Create `apps/README.md` — naming convention, scope subdir name = app name, port/env conventions
- [ ] **t2.02** Create `services/README.md` — backend equivalent
- [ ] **t2.03** Create `packages/README.md` — shared libraries; cross-language allowed
- [ ] **t2.04** Create `tools/README.md` — local tooling, generators, dev-only utilities

### Phase 3 — Documentation scaffold
- [ ] **t3.01** Create `docs/README.md` — map: specs/, plans/, adr/; scope subdirs (platform/, <service>/, <app>/); when to use each
- [ ] **t3.02** Create `docs/specs/README.md` — when to write a spec, naming (`NNNN-slug.md`), scope rules
- [ ] **t3.03** Create `docs/specs/TEMPLATE.md` — Goal, Non-goals, User stories, Acceptance criteria, Open questions
- [ ] **t3.04** Create `docs/specs/platform/.gitkeep`
- [ ] **t3.05** Create `docs/plans/README.md` — every plan must have a Checklist section + Loop Recipe
- [ ] **t3.06** Create `docs/plans/TEMPLATE.md` — frontmatter (id, status, scope, owner, created, updated, loop_driver, loop_prompt) + sections matching this plan's structure
- [ ] **t3.07** Create `docs/adr/README.md` — when to write an ADR, status lifecycle (proposed/accepted/superseded)
- [ ] **t3.08** Create `docs/adr/TEMPLATE.md` — Nygard-style: Context, Decision, Consequences
- [ ] **t3.09** Create `docs/adr/platform/0001-record-architecture-decisions.md` (meta ADR)
- [ ] **t3.10** Create `docs/adr/platform/0002-monorepo-layout.md`
- [ ] **t3.11** Create `docs/adr/platform/0003-make-as-orchestrator.md`
- [ ] **t3.12** Create `docs/adr/platform/0004-pi-as-default-harness.md`
- [ ] **t3.13** Create `docs/adr/platform/0005-ralph-loop-mandate.md`
- [ ] **t3.14** Create `docs/adr/platform/0006-progressive-disclosure-for-ai.md`

### Phase 4 — Scripts
- [ ] **t4.01** Confirm `scripts/ralph.sh` is present (created in genesis); harden if needed: iter cap, log dir, harness env var
- [ ] **t4.02** Create `scripts/harness.sh` — dispatch wrapper: `pi` (default) | `claude` | `codex`
- [ ] **t4.03** Create `scripts/new-spec.sh` — copy `docs/specs/TEMPLATE.md` into `<scope>/<NNNN>-<slug>.md`
- [ ] **t4.04** Create `scripts/new-plan.sh` — same for plans
- [ ] **t4.05** Create `scripts/new-adr.sh` — same for ADRs
- [ ] **t4.06** Make all `scripts/*.sh` executable (`chmod +x`)

### Phase 5 — Build & loop entry
- [ ] **t5.01** Create `Makefile` — targets: `help`, `ralph`, `new-spec NAME=…`, `new-plan NAME=…`, `new-adr NAME=…`, `lint-docs`, `ci`
- [ ] **t5.02** Confirm `PROMPT.md` is present (created in genesis); ensure it instructs the agent to read this plan and pick exactly one task

### Phase 6 — GitHub integration
- [ ] **t6.01** Create `.github/workflows/ci.yml` — minimal: shellcheck on `scripts/`, markdown lint on `docs/`, tree integrity check
- [ ] **t6.02** Create `.github/workflows/ralph-guard.yml` — fail PRs that change `docs/plans/**` or `docs/specs/**` without a corresponding entry in `.ralph/logs/` or commit trailer `Ralph-Run: <plan-id>`
- [ ] **t6.03** Create `.github/ISSUE_TEMPLATE/bug.md`
- [ ] **t6.04** Create `.github/ISSUE_TEMPLATE/feature.md`
- [ ] **t6.05** Create `.github/ISSUE_TEMPLATE/spec.md` (links to spec template)
- [ ] **t6.06** Create `.github/PULL_REQUEST_TEMPLATE.md` — checklist: spec linked, plan linked, ADR if architectural, Ralph log if applicable

### Phase 7 — Verification
- [ ] **t7.01** Run `make help` and confirm all documented targets list
- [ ] **t7.02** Run `bash scripts/ralph.sh --dry-run` and confirm harness dispatch resolves for `pi`, `claude`, `codex`
- [ ] **t7.03** Run `make lint-docs` and confirm no failures
- [ ] **t7.04** Mark this plan `status: complete` in frontmatter; bump `updated`
- [ ] **t7.05** Output `<promise>COMPLETE</promise>` and stop the loop

## 7. Loop Recipe

```bash
# From repo root, with pi installed: npm i -g @mariozechner/pi-coding-agent
# To use a different harness: AI_HARNESS=claude  or  AI_HARNESS=codex
bash scripts/ralph.sh
```

Manual one-shot equivalent (no script):

```bash
mkdir -p .ralph/logs
while true; do
  pi -p < PROMPT.md | tee -a .ralph/logs/last.log
  grep -q "<promise>COMPLETE</promise>" .ralph/logs/last.log && break
done
```

The loop must:
1. Re-read `AGENTS.md` and this plan each iteration (fresh context).
2. Pick the first unchecked checkbox in §6.
3. Implement only that task. No bundling.
4. Check the box (`- [ ]` → `- [x]`).
5. Append a one-line summary to `.ralph/logs/last.log`.
6. Exit. The driver restarts with new context.
7. When all tasks in §6 are checked, output `<promise>COMPLETE</promise>` exactly.

## 8. Acceptance criteria

- Cloning the repo and running `make help` shows the documented targets.
- `bash scripts/ralph.sh --help` prints usage and lists supported harnesses.
- `AGENTS.md` exists and is under ~100 lines.
- `CLAUDE.md` resolves to `AGENTS.md` via symlink.
- All checklist items in §6 are checked.
- `.github/workflows/*` parse without errors.
- License is MIT and dated 2026.

## 9. Open questions (revisit, do not block v0)

- Ship a `.mise.toml` for tool-version pinning even though Make is the orchestrator?
- Add `scripts/new-service.sh` as an empty hook for future per-language generators?
- Add a `docs/runbooks/` folder, or defer to per-service runbooks?
- Add `lefthook` or stick with documentation-only pre-commit guidance?

File new plans for any of these as needed; they are explicitly out of scope for v0.
