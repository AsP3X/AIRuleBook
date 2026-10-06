# Sources

Every agent-rule file found under `Documents/development` on 2026-10-05, where its verbatim copy
lives in `originals/`, and which generalized rule(s) it feeds.

## ownly (`ownly/`)

| Original | Copy | Generalized into |
|---|---|---|
| `.cursor/rules/agent.mdc` | `originals/ownly/.cursor/rules/agent.mdc` | `rules/core/agent-non-negotiables.md` |
| `.cursor/rules/api-error-shape.mdc` | same path under `originals/ownly/` | `rules/backend/api-error-envelope.md` (variant A) |
| `.cursor/rules/api-sqlx-migrations.mdc` | 〃 | `rules/backend/sql-migrations-immutable.md` |
| `.cursor/rules/audit-log-coverage.mdc` | 〃 | `rules/backend/audit-log-coverage.md` |
| `.cursor/rules/data-safety.mdc` | 〃 | `rules/safety/data-safety.md` |
| `.cursor/rules/docker-compose-safety.mdc` | 〃 | `rules/safety/docker-compose-safety.md` |
| `.cursor/rules/frontend-npm-lockfile-docker.mdc` | 〃 | `rules/frontend/npm-lockfile-linux-docker.md` |
| `.cursor/rules/git-commits.mdc` | 〃 | `rules/git/git-commits.md` (branch model B) |
| `.cursor/rules/inline-documentation.mdc` | 〃 | `rules/quality/inline-documentation.md` (TSX form) |
| `.cursor/rules/nebular-os-vendor.mdc` | 〃 | `rules/architecture/vendored-submodule-readonly.md` |
| `.cursor/rules/plan-execution.mdc` | 〃 | `rules/workflow/plan-execution.md` |
| `.cursor/rules/regression-testing.mdc` | 〃 | `rules/workflow/regression-testing.md` |
| `.cursor/rules/rust/no-allow-dead-code.mdc` | 〃 | `rules/languages/rust/rust-no-dead-code-allow.md` |
| `.cursor/rules/security-audit-scripts.mdc` | 〃 | `rules/security/security-audit-scripts.md` |
| `.githooks/pre-commit` | 〃 | `tooling/git-hooks/pre-commit-submodule-guard.sh` |

## nebular-os (`ownly/nebular-os/`, also mirrored in `downvid/.nebular-os-ref/`)

| Original | Copy | Generalized into |
|---|---|---|
| `AGENTS.md` | `originals/nebular-os/AGENTS.md` | `rules/architecture/project-layout.template.md` (commands + gotchas sections) |
| `.cursor/rules/agent.mdc` | `originals/nebular-os/.cursor/rules/agent.mdc` | `rules/core/agent-non-negotiables.md` |
| `.cursor/rules/api-error-shape.mdc` | 〃 | `rules/backend/api-error-envelope.md` (variant B) |
| `.cursor/rules/git-commits.mdc` | 〃 | `rules/git/git-commits.md` (base text, branch model A), `rules/git/no-ai-attribution.md` |
| `.cursor/rules/inline-documentation.mdc` | 〃 | `rules/quality/inline-documentation.md` (base text) |
| `.cursor/rules/plan-execution.mdc` | 〃 | `rules/workflow/plan-execution.md` (base text) |
| `.cursor/rules/project-layout.mdc` | 〃 | `rules/architecture/project-layout.template.md` |
| `.cursor/rules/rust/no-allow-dead-code.mdc` | 〃 | `rules/languages/rust/rust-no-dead-code-allow.md` |

The `downvid/.nebular-os-ref/` copies are byte-identical to the above except `AGENTS.md`, line 11
(Rust 1.85 / edition 2024 instead of 1.88 / let-chains), so they are not copied again.

## shroud (`shroud/`)

| Original | Copy | Generalized into |
|---|---|---|
| `AGENTS.md` | `originals/shroud/AGENTS.md` | `templates/AGENTS.md.template` (index-table pattern) |
| `CLAUDE.md` | `originals/shroud/CLAUDE.md` | `templates/CLAUDE.md.template` |
| `docs/agent-rules/design-sync.md` | 〃 | `rules/frontend/design-sync.md` |
| `docs/agent-rules/no-ai-attribution.md` | 〃 | `rules/git/no-ai-attribution.md` |
| `docs/agent-rules/no-deprecated-apis.md` | 〃 | `rules/quality/no-deprecated-apis.md` |
| `docs/agent-rules/worktrees-from-dev.md` | 〃 | `rules/git/worktrees-from-base-branch.md` |
| `.cursor/rules/agent.mdc` | 〃 | `rules/core/agent-non-negotiables.md` |
| `.cursor/rules/api-error-shape.mdc` | 〃 | `rules/backend/api-error-envelope.md` |
| `.cursor/rules/api-sqlx-migrations.mdc` | 〃 | `rules/backend/sql-migrations-immutable.md` |
| `.cursor/rules/data-safety.mdc` | 〃 | `rules/safety/data-safety.md` |
| `.cursor/rules/definition-of-done.mdc` | 〃 | `rules/workflow/definition-of-done.md` |
| `.cursor/rules/design-system.mdc` | 〃 | `rules/frontend/design-system.template.md` (full example stays in originals) |
| `.cursor/rules/git-commits.mdc` | 〃 | `rules/git/git-commits.md` |
| `.cursor/rules/inline-documentation.mdc` | 〃 | `rules/quality/inline-documentation.md` |
| `.cursor/rules/project-layout.mdc` | 〃 | `rules/architecture/project-layout.template.md`, `rules/frontend/design-sync.md` |
| `.cursor/rules/regression-testing.mdc` | 〃 | `rules/workflow/regression-testing.md` (backtesting section) |
| `.cursor/rules/rust-quality.mdc` | 〃 | `rules/languages/rust/rust-quality.md` |
| `.cursor/rules/security-crypto.mdc` | 〃 | `rules/security/security-e2e-crypto.md` |
| `.cursor/rules/swift-quality.mdc` | 〃 | `rules/languages/swift/swift-quality.md` |
| `.claude/settings.json` | 〃 | `tooling/claude/settings.json` |
| `.claude/hooks/sync-worktree-with-dev.sh` | 〃 | `tooling/hooks/sync-worktree-with-base.sh` |
| `.claude/android-ui/BRIEF.md` | 〃 | `templates/agent-brief.template.md` |
| `.claude/workflows/wave.js` | 〃 | example only (multi-agent wave orchestration) |

## pzserver (`pzserver/`)

| Original | Copy | Generalized into |
|---|---|---|
| `AGENTS.md` | `originals/pzserver/AGENTS.md` | `rules/architecture/single-source-of-truth.md`, `rules/release/deploy-to-running-targets.md`, `rules/release/release-versioning-needs-approval.md`, `rules/languages/rust/rust-no-dead-code-allow.md` |
| `CLAUDE.md` | `originals/pzserver/CLAUDE.md` | `rules/frontend/i18n-no-hardcoded-strings.md`, `rules/quality/codebase-conventions.md`, `rules/backend/audit-log-coverage.md`, `rules/security/security-e2e-crypto.md` (server defaults) |

## New rules (written 2026-10-05, not harvested)

These close gaps found when reviewing the library against common agent failure modes. Where a project already had a hint of the rule, it is listed.

| Rule | Prompted by |
|---|---|
| `rules/workflow/scope-discipline.md` | — |
| `rules/workflow/test-integrity.md` | shroud `wave.js`: "tests silently pass as skipped" |
| `rules/workflow/root-cause-debugging.md` | — |
| `rules/workflow/docs-upkeep.md` | shroud `AGENTS.md` "Adding or changing a rule" |
| `rules/workflow/session-handoff.md` | shroud `.claude/android-ui/PROGRESS.md`, `HANDOVER-*.md`, `resume-*.md` |
| `rules/safety/external-actions.md` | pzserver "always ask before a Workshop release" |
| `rules/security/secrets-handling.md` | secret bullets in ownly/shroud `git-commits`, `api-error-shape`, `security-audit-scripts` |
| `rules/security/untrusted-content.md` | — |
| `rules/security/web-security-baseline.md` | pzserver Security Conventions, shroud `security-crypto.mdc` server rules |
| `rules/security/dependency-safety.md` | pzserver `CLAUDE.md` "Do not change dependencies without approval" |
| `rules/languages/typescript/typescript-quality.md` | ownly `frontend/`, pzserver `web/ui`, shroud `web/` |
| `rules/languages/typescript/react-quality.md` | same |
| `rules/languages/kotlin/kotlin-quality.md` | shroud `BRIEF.md` contract rules |
| `rules/languages/kotlin/android-quality.md` | shroud `BRIEF.md` R1–R4, build gate, emulator rules |
| `rules/languages/python/python-quality.md` | ownly `scripts/security-audit/` |
| `rules/frontend/web-accessibility.md` | shroud `design-system.mdc` quality gate (iOS) |
| `rules/backend/backend-performance.md` | — |
| `rules/environment/cross-platform-scripts.md` | pzserver `deploy.sh`/`deploy.ps1`, `make.ps1`; ownly lockfile bug; shroud hardcoded `/Users/…` paths |
| `rules/environment/env-config-sync.md` | ownly `.env.example` + `init-env.sh`, nebular-os `NOS_*`, pzserver `.env.production.example` |

## Notable differences between project variants

- **Branch model:** nebular-os uses `master` + `feat/*` (no `dev`). ownly and shroud use `feature/*` → `dev` → `master`. Both are kept as options in `git-commits.md`.
- **Error envelope:** ownly and shroud use `{ "error": { "code", "message" } }`; nebular-os uses the flat `{ "error": "…" }`. Both are kept as variants in `api-error-envelope.md`.
- **Inline docs scope:** nebular-os `*.rs`; ownly `*.rs,ts,tsx` (adds the JSX comment form); shroud `*.rs,swift` (adds crypto-flow comments). All merged.
- **Dead-code rule:** pzserver goes further (also `cfg_attr`, no `expect`/dummy reads, enforced by a grep script). The library uses the stricter version.
- **Commit cadence:** interactive agents commit only on request; shroud's multi-agent brief tells autonomous agents in their own worktree to "commit early and often". `git-commits.md` documents that exception.
