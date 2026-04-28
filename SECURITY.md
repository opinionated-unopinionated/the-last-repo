# Security Policy

## Reporting a vulnerability

The Last Repo is a public scaffold maintained by the open-source community. If you believe you have found a security issue in this repository — in the loop driver, the harness scripts, the CI workflows, or any committed configuration — please report it privately. Do **not** open a public issue or pull request that describes the vulnerability.

### How to report

Use one of the following private channels, in order of preference:

1. **GitHub private vulnerability reporting.** From the repository's `Security` tab, choose `Report a vulnerability`. This opens a private advisory visible only to maintainers.
2. **Email.** Send a description and reproduction steps to the address listed in the repository's `README.md` under "Security", or to the active maintainer listed in the most recent `CODEOWNERS` entry. If neither is available, open a minimal public issue asking for a private contact and a maintainer will respond.

Please include, where possible:

- A description of the issue and the impact you believe it has.
- Steps to reproduce, including the commit SHA and harness (`pi`, `claude`, or `codex`) you were running.
- Any logs, command transcripts, or `.ralph/logs/` excerpts that demonstrate the issue. Redact secrets before sending.
- Your assessment of severity and any suggested mitigations.

### What to expect

- **Acknowledgement** within 5 business days.
- **Triage** — a maintainer will confirm the report, reproduce the issue if possible, and assign a severity.
- **Fix and disclosure** — for confirmed issues, we aim to ship a fix and a coordinated disclosure within 90 days of acknowledgement. We will credit the reporter unless anonymity is requested.

### Scope

In scope:

- Code in this repository: `scripts/`, `Makefile`, `.github/workflows/`, committed configuration, and documentation that prescribes commands to run.
- Supply-chain concerns specific to this repository, such as a script that fetches an unverified remote resource.

Out of scope:

- Vulnerabilities in third-party harnesses (`pi`, `claude`, `codex`) — report those upstream.
- Vulnerabilities in user code that lives in forks or downstream copies of this scaffold.
- Issues that require an attacker to already have local shell access on a developer's machine.

### Safe harbor

We will not pursue legal action against researchers who:

- Make a good-faith effort to follow this policy.
- Avoid privacy violations, data destruction, and service disruption.
- Give us reasonable time to remediate before any public disclosure.

This is a stub policy for a v0 scaffold. It will be revised as the project matures; track changes in `docs/adr/platform/` and the repository's `Security` tab.
