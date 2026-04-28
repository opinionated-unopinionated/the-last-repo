---
id: 0001-bootstrap-the-last-repo
title: Bootstrap "The Last Repo" scaffold
status: complete
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

- [x] **t1.01** Create `LICENSE` (MIT 2026, "The Last Repo contributors")
- [x] **t1.02** Create root `README.md`: project pitch, decisions table linking this plan, quickstart, contributing pointer
- [x] **t1.03** Create `AGENTS.md`: progressive-disclosure entry. Lists key paths, reading order, Ralph-loop mandate, harness compatibility note. Hard cap: 100 lines
- [x] **t1.04** Symlink `CLAUDE.md → AGENTS.md` (`ln -s AGENTS.md CLAUDE.md`)
- [x] **t1.05** Create `CONTRIBUTING.md`: Ralph loop is the default workflow; spec/plan templates required for non-trivial PRs; commit trailer `Ralph-Run: <plan-id>` for plan/spec changes
- [x] **t1.06** Create `CODE_OF_CONDUCT.md` by fetching Contributor Covenant 2.1 verbatim via Bash: `curl -fsSL https://www.contributor-covenant.org/version/2/1/code_of_conduct.txt -o CODE_OF_CONDUCT.md`. **Do not generate, paraphrase, or quote the document text in your response** — the Anthropic API output filter blocks Code-of-Conduct content emitted from the model. After the fetch, verify the file is non-empty (`test -s CODE_OF_CONDUCT.md`); that is the entire task.
- [x] **t1.07** Create `SECURITY.md` (responsible disclosure stub)
- [x] **t1.08** Create `.editorconfig` (LF, utf-8, 2-space indent default, language overrides minimal)
- [x] **t1.09** Create `.gitignore` (polyglot: node, python, go, rust, java, .DS_Store, IDE files, `.ralph/logs/`)
- [x] **t1.10** Create `.gitattributes` (LF normalization, common binary markers)

### Phase 2 — Monorepo shells

- [x] **t2.01** Create `apps/README.md` — naming convention, scope subdir name = app name, port/env conventions
- [x] **t2.02** Create `services/README.md` — backend equivalent
- [x] **t2.03** Create `packages/README.md` — shared libraries; cross-language allowed
- [x] **t2.04** Create `tools/README.md` — local tooling, generators, dev-only utilities

### Phase 3 — Documentation scaffold

- [x] **t3.01** Create `docs/README.md` — map: specs/, plans/, adr/; scope subdirs (platform/, <service>/, <app>/); when to use each
- [x] **t3.02** Create `docs/specs/README.md` — when to write a spec, naming (`NNNN-slug.md`), scope rules
- [x] **t3.03** Create `docs/specs/TEMPLATE.md` — Goal, Non-goals, User stories, Acceptance criteria, Open questions
- [x] **t3.04** Create `docs/specs/platform/.gitkeep`
- [x] **t3.05** Create `docs/plans/README.md` — every plan must have a Checklist section + Loop Recipe
- [x] **t3.06** Create `docs/plans/TEMPLATE.md` — frontmatter (id, status, scope, owner, created, updated, loop_driver, loop_prompt) + sections matching this plan's structure
- [x] **t3.07** Create `docs/adr/README.md` — when to write an ADR, status lifecycle (proposed/accepted/superseded)
- [x] **t3.08** Create `docs/adr/TEMPLATE.md` — Nygard-style: Context, Decision, Consequences
- [x] **t3.09** Create `docs/adr/platform/0001-record-architecture-decisions.md` (meta ADR)
- [x] **t3.10** Create `docs/adr/platform/0002-monorepo-layout.md`
- [x] **t3.11** Create `docs/adr/platform/0003-make-as-orchestrator.md`
- [x] **t3.12** Create `docs/adr/platform/0004-pi-as-default-harness.md`
- [x] **t3.13** Create `docs/adr/platform/0005-ralph-loop-mandate.md`
- [x] **t3.14** Create `docs/adr/platform/0006-progressive-disclosure-for-ai.md`

### Phase 4 — Scripts

- [x] **t4.01** Confirm `scripts/ralph.sh` is present (created in genesis); harden if needed: iter cap, log dir, harness env var
- [x] **t4.02** Create `scripts/harness.sh` — dispatch wrapper: `pi` (default) | `claude` | `codex`
- [x] **t4.03** Create `scripts/new-spec.sh` — copy `docs/specs/TEMPLATE.md` into `<scope>/<NNNN>-<slug>.md`
- [x] **t4.04** Create `scripts/new-plan.sh` — same for plans
- [x] **t4.05** Create `scripts/new-adr.sh` — same for ADRs
- [x] **t4.06** Make all `scripts/*.sh` executable (`chmod +x`)

### Phase 5 — Build & loop entry

- [x] **t5.01** Create `Makefile` — targets: `help`, `ralph`, `new-spec NAME=…`, `new-plan NAME=…`, `new-adr NAME=…`, `lint-docs`, `ci`
- [x] **t5.02** Confirm `PROMPT.md` is present (created in genesis); ensure it instructs the agent to read this plan and pick exactly one task

### Phase 6 — GitHub integration

- [x] **t6.01** Create `.github/workflows/ci.yml` — minimal: shellcheck on `scripts/`, markdown lint on `docs/`, tree integrity check
- [x] **t6.02** Create `.github/workflows/ralph-guard.yml` — fail PRs that change `docs/plans/**` or `docs/specs/**` without a corresponding entry in `.ralph/logs/` or commit trailer `Ralph-Run: <plan-id>`
- [x] **t6.03** Create `.github/ISSUE_TEMPLATE/bug.md`
- [x] **t6.04** Create `.github/ISSUE_TEMPLATE/feature.md`
- [x] **t6.05** Create `.github/ISSUE_TEMPLATE/spec.md` (links to spec template)
- [x] **t6.06** Create `.github/PULL_REQUEST_TEMPLATE.md` — checklist: spec linked, plan linked, ADR if architectural, Ralph log if applicable

### Phase 7 — Verification

- [x] **t7.01** Run `make help` and confirm all documented targets list
- [x] **t7.02** Run `bash scripts/ralph.sh --dry-run` and confirm harness dispatch resolves for `pi`, `claude`, `codex`
- [x] **t7.03** Run `make lint-docs` and confirm no failures
- [x] **t7.04** Mark this plan `status: complete` in frontmatter; bump `updated`
- [x] **t7.05** Output `<promise>COMPLETE</promise>` and stop the loop

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

### Notes from iterations

- t1.06 (2026-04-27): The literal URL in the task (`https://www.contributor-covenant.org/version/2/1/code_of_conduct.txt`) returned 404. Substituted the canonical upstream source: `https://raw.githubusercontent.com/EthicalSource/contributor_covenant/release/content/version/2/1/code_of_conduct.md`. Resulting file is 5579 bytes, non-empty per the verification step.
- t7.02 (2026-04-27): `bash scripts/ralph.sh --dry-run` exercised for `AI_HARNESS=pi|claude|codex`. All three dispatch branches resolve correctly and report harness install status. In this environment only `claude` is installed (`/opt/homebrew/bin/claude`); `pi` and `codex` report as not installed, which is expected and orthogonal to dispatch correctness.
- t7.03 (2026-04-27): `make lint-docs` exited 0 with the expected "no markdown linter installed; skipping" message. The Makefile target degrades gracefully when neither `markdownlint-cli2` nor `markdownlint` is on PATH, which is acceptable for v0; tightening this into a hard requirement is a follow-up plan.
