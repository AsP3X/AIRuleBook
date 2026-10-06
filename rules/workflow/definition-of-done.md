---
description: Single pre-completion checklist the agent must satisfy with evidence before claiming work is done, fixed or passing
alwaysApply: true
---

# Definition of done

**Applies to:** the end of every substantive piece of work.

**Out of scope:** how checks must be run honestly (`test-integrity.md`), what to test (`regression-testing.md`).

**Origin:** `shroud` (`definition-of-done.mdc`), generalized.

**Customize:** keep only the checklist rows your project has; replace the commands; link the rules you installed.

Do not claim work is complete, fixed or passing until **every applicable item below is satisfied with evidence**. State the evidence (commands run + outcomes). If something is blocked, say so with the exact command the user must run. **Evidence before assertions — always.**

## Checklist (apply what is relevant)

1. **Scope** — you read your full diff; every hunk is needed by the task; out-of-scope findings are listed, not fixed (`scope-discipline.md`).
2. **Builds** — every touched component builds ({{BUILD_COMMANDS}}).
3. **Lint / format / types** — formatter check clean; linter and type checker clean with warnings as errors; **no new suppressions** (see the language quality rules).
4. **Tests** — the regression-matrix rows for your change type pass; new behavior has tests; bug fixes have a guarding test that failed before the fix; protocol changes have archived fixtures and passing backtests (`regression-testing.md`). Nothing was skipped, weakened or deleted to get green (`test-integrity.md`). Report passed / failed / skipped counts.
5. **Migrations** — schema changes are new forward migration files only (`sql-migrations-immutable.md`).
6. **Security** — no secrets in code, output, logs or commits (`secrets-handling.md`); new endpoints pass the review checklist (`web-security-baseline.md`); crypto checklist passed where relevant (`security-e2e-crypto.md`).
7. **Dependencies** — every added or upgraded package is approved, verified, locked and audited (`dependency-safety.md`).
8. **Audit** — every new mutation is audited or explicitly exempt (`audit-log-coverage.md`).
9. **Config** — new or changed env vars are in `.env.example`, deployment files and docs (`env-config-sync.md`).
10. **UI** — matches the design source and uses design-system tokens; the design file was updated (`design-sync.md`, `design-system`); accessibility checks pass (`web-accessibility.md`).
11. **Docs** — inline comments added (`inline-documentation.md`); README / API / config docs updated where the change made them stale (`docs-upkeep.md`).
12. **No unapproved side effects** — nothing destructive ran locally without permission (`data-safety.md`); nothing external ran without approval (`external-actions.md`).
13. **Deployed where it must run** — if the change has to be live in a running environment to count, it is, and you verified the running version (`deploy-to-running-targets.md`).

## Reporting

End substantive work with a short evidence summary: commands and results (e.g. `cargo test --workspace`: 87 passed; clippy: clean; `npm run build`: ok), manual smoke paths exercised, plus any blocked items and how to unblock them. Do not say "done" without it.
