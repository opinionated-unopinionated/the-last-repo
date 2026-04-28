# The Last Repo

An opinionated, AI-first, polyglot monorepo scaffold you can clone, extend, and ship from on day one.

The Last Repo is built by the same loop it teaches: a [Ralph Wiggum loop](https://ghuntley.com/ralph/) drives a coding-agent harness through a checklist plan, one iteration at a time, until the scaffold is complete. The scaffold's bootstrap plan lives at [`docs/plans/platform/0001-bootstrap-the-last-repo.md`](docs/plans/platform/0001-bootstrap-the-last-repo.md) — that file is the proof that the loop works on day one, and the canonical example of how to author plans in this repo.

## Locked decisions

These are the v0 defaults. Each is recorded as an ADR under `docs/adr/platform/`.

| #  | Topic               | Choice                                                              |
| -- | ------------------- | ------------------------------------------------------------------- |
| 1  | Polyglot scope      | Empty language-agnostic shells (`apps/`, `services/`, `packages/`, `tools/`) |
| 2  | Build orchestrator  | Plain Make                                                          |
| 3  | Bootstrap mode      | `git clone` (no installer)                                          |
| 4  | Ralph enforcement   | `ralph.sh` + `AGENTS.md` mandate + plan template + CI guard         |
| 5  | Harness selection   | `AGENTS.md` canonical; `CLAUDE.md` symlinks to it; Codex reads it natively |
| 6  | Default AI harness  | [`@mariozechner/pi-coding-agent`](https://www.npmjs.com/package/@mariozechner/pi-coding-agent) |
| 7  | CI provider         | GitHub Actions                                                      |
| 8  | Doc layout          | `docs/{specs,plans,adr}/<scope>/` flat tree                         |
| 9  | License             | MIT                                                                 |

Full rationale: [`docs/plans/platform/0001-bootstrap-the-last-repo.md`](docs/plans/platform/0001-bootstrap-the-last-repo.md) §3.

## Quickstart

```bash
git clone <your-fork-url> the-last-repo
cd the-last-repo

# Install the default harness (or set AI_HARNESS=claude | codex to use a different one)
npm i -g @mariozechner/pi-coding-agent

# Drive the bootstrap loop until it self-completes
bash scripts/ralph.sh

# Or use Make
make ralph
```

The loop reads `AGENTS.md` and the active plan each iteration, picks the first unchecked task, implements it, checks the box, logs to `.ralph/logs/last.log`, and exits. The driver restarts it with fresh context until every task is checked.

To see all available targets:

```bash
make help
```

## Contributing

The Ralph loop is the default workflow. Non-trivial changes start with a spec or plan under `docs/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full flow, commit-trailer conventions, and PR checklist.

## License

MIT — see [`LICENSE`](LICENSE).
