# AI Rules Library

A library of tested AI coding-agent rules, collected from the projects in `Documents/development` and
generalized so they can be reused in any project. Every rule works with every agent: Claude Code,
Cursor, Codex, Copilot, Gemini, Grok and anything else that reads `AGENTS.md`.

Collected 2026-10-05 from **ownly**, **nebular-os** (ownly submodule), **shroud** and **pzserver**.
`SOURCES.md` lists where each rule came from.

## Layout

```
AI-Rules-Library/
├── README.md                 ← you are here (index + how to use)
├── SOURCES.md                ← provenance: original file → library rule
├── rules/                    ← generalized, reusable rules (one rule per file)
│   ├── core/                 ← the entry point every project gets
│   ├── git/                  ← commits, attribution, worktrees
│   ├── safety/               ← local data loss, Docker volumes, external/production actions
│   ├── workflow/             ← scope, plans, done, testing, debugging, docs, handoff
│   ├── quality/              ← inline docs, conventions, deprecated APIs
│   ├── languages/            ← rust, swift, typescript (+react), kotlin (+android), python
│   ├── backend/              ← API errors, migrations, audit logs, performance
│   ├── frontend/             ← lockfiles, i18n, accessibility, design sync, design system
│   ├── security/             ← secrets, untrusted content, web baseline, dependencies, E2E crypto, audit scripts
│   ├── environment/          ← cross-platform scripts, env/config sync
│   ├── architecture/         ← layout, submodules, source of truth
│   └── release/              ← deploy verification, version bumps
├── templates/                ← AGENTS.md, CLAUDE.md, multi-agent brief
├── tooling/                  ← Claude settings, SessionStart hook, git hooks
└── originals/                ← verbatim copies of every source file, by project
```

## Using the library in a project

1. Copy `templates/AGENTS.md.template` → `AGENTS.md` and `templates/CLAUDE.md.template` → `CLAUDE.md`.
2. Copy the rules you want into `docs/agent-rules/`. Drop `.template` from the name.
3. For each rule, add a row to the table in `AGENTS.md` and an `@docs/agent-rules/<rule>.md` line to `CLAUDE.md`.
4. For Cursor, also copy the rules to `.cursor/rules/<rule>.mdc`; the frontmatter is already Cursor-compatible.
5. Fill in every `{{PLACEHOLDER}}` and delete the sections that don't apply:

```bash
grep -rn '{{' AGENTS.md docs/agent-rules
```

## Recommended bundles

| Bundle | Rules | Use for |
|---|---|---|
| Minimal | agent-non-negotiables, git-commits, no-ai-attribution, scope-discipline, data-safety, external-actions, secrets-handling, untrusted-content, definition-of-done | Any repo, including scripts and docs |
| Core | Minimal + plan-execution, regression-testing, test-integrity, root-cause-debugging, codebase-conventions, no-deprecated-apis, inline-documentation, docs-upkeep, dependency-safety, env-config-sync, cross-platform-scripts | Any real application |
| Rust | rust-quality, rust-no-dead-code-allow | Rust crates and workspaces |
| Swift | swift-quality | iOS / macOS apps |
| Android | kotlin-quality, android-quality | Android apps (Compose) |
| Python | python-quality | Python tooling and services |
| Backend | api-error-envelope, sql-migrations-immutable, audit-log-coverage, web-security-baseline, backend-performance | HTTP APIs with a SQL database |
| Docker | docker-compose-safety | Anything run with Docker Compose |
| Web | typescript-quality, react-quality, web-accessibility, i18n-no-hardcoded-strings, npm-lockfile-linux-docker | TypeScript/React frontends (drop the lockfile rule if not built in Docker) |
| Design | design-sync, design-system (template) | Apps with a design file (Pencil, Figma) |
| E2E | security-e2e-crypto | Encrypted messengers, vaults, key custody |
| Release | deploy-to-running-targets, release-versioning-needs-approval | Mods, plugins, published artifacts, device apps |
| Long-running agents | session-handoff, worktrees-from-base-branch, plus `templates/agent-brief.template.md` | Multi-session or multi-agent work |
| Layout | project-layout (template) | Every repo where agents need to know what goes where |

`architecture/vendored-submodule-readonly`, `architecture/single-source-of-truth` and
`security/security-audit-scripts` are not in any bundle. Add them when they fit.

## Rule catalog

| Rule | Category | What it enforces | Source ("new" = written to close a gap) |
|---|---|---|---|
| [agent-non-negotiables](rules/core/agent-non-negotiables.md) | core | Rules are binding; routes git, data and completion questions to their own rules | ownly, nebular-os, shroud |
| [git-commits](rules/git/git-commits.md) | git | Commit/push/merge only on explicit request; `TASK/FIX/BUGFIX/DOCS/CHORE` prefixes; staging scope; no secrets; no `--no-verify`; two branch models | nebular-os, ownly, shroud |
| [no-ai-attribution](rules/git/no-ai-attribution.md) | git | No `Co-Authored-By` / "Generated with" for AI in commits and PRs | shroud, nebular-os |
| [worktrees-from-base-branch](rules/git/worktrees-from-base-branch.md) | git | Worktrees start from an up-to-date `dev` and catch up again before testing and merging | shroud |
| [data-safety](rules/safety/data-safety.md) | safety | No destructive action without explicit permission for that action; "fix it" does not count | ownly, shroud |
| [docker-compose-safety](rules/safety/docker-compose-safety.md) | safety | Never `down -v`; no new compose variants; no renaming containers or volumes | ownly |
| [plan-execution](rules/workflow/plan-execution.md) | workflow | Plans are binding checklists; verify; loop until every item is done | nebular-os, ownly |
| [definition-of-done](rules/workflow/definition-of-done.md) | workflow | Evidence (commands + results) before "done" | shroud |
| [regression-testing](rules/workflow/regression-testing.md) | workflow | Preserve contracts; test the blast radius; guard every bug fix; fixture backtests | ownly, shroud |
| [inline-documentation](rules/quality/inline-documentation.md) | quality | `Human:` + `Agent:` comment pairs on non-trivial code | nebular-os, ownly, shroud |
| [codebase-conventions](rules/quality/codebase-conventions.md) | quality | Match siblings, reuse first, no new folders or dependencies without approval, robustness defaults | pzserver, shroud, nebular-os |
| [no-deprecated-apis](rules/quality/no-deprecated-apis.md) | quality | No deprecated calls, shims or suppressions | shroud |
| [rust-quality](rules/languages/rust/rust-quality.md) | rust | No panics in production paths; typed errors; no blocking in async; justified `unsafe` | shroud |
| [rust-no-dead-code-allow](rules/languages/rust/rust-no-dead-code-allow.md) | rust | `#[allow(dead_code)]` forbidden, enforced by lint + grep | nebular-os, ownly, pzserver |
| [swift-quality](rules/languages/swift/swift-quality.md) | swift | No force unwraps; MVVM; `@MainActor`; previews; Dynamic Type | shroud |
| [api-error-envelope](rules/backend/api-error-envelope.md) | backend | One JSON error shape (structured or flat); safe messages; clients updated in the same change | ownly, shroud, nebular-os |
| [sql-migrations-immutable](rules/backend/sql-migrations-immutable.md) | backend | Never edit applied migrations; forward-fix | ownly, shroud |
| [audit-log-coverage](rules/backend/audit-log-coverage.md) | backend | Every mutation/admin action is audited or explicitly exempt | ownly, pzserver |
| [npm-lockfile-linux-docker](rules/frontend/npm-lockfile-linux-docker.md) | frontend | Regenerate `package-lock.json` in the Linux build image | ownly |
| [i18n-no-hardcoded-strings](rules/frontend/i18n-no-hardcoded-strings.md) | frontend | All UI copy through `t()` and in every locale | pzserver |
| [design-sync](rules/frontend/design-sync.md) | frontend | Every UI change also lands in the design file; Pencil `.pen` notes | shroud |
| [design-system (template)](rules/frontend/design-system.template.md) | frontend | Tokens, typography, recipes, composition, UI quality gate | shroud |
| [security-e2e-crypto](rules/security/security-e2e-crypto.md) | security | Plaintext and keys never leave the device; no hand-rolled crypto | shroud |
| [security-audit-scripts](rules/security/security-audit-scripts.md) | security | Standalone probe scripts: stdlib, redaction, exit codes, SARIF | ownly |
| [project-layout (template)](rules/architecture/project-layout.template.md) | architecture | What each path is for, where code goes, commands, gotchas | nebular-os, shroud |
| [vendored-submodule-readonly](rules/architecture/vendored-submodule-readonly.md) | architecture | Never edit a submodule; send patches upstream; bump the pointer only | ownly |
| [single-source-of-truth](rules/architecture/single-source-of-truth.md) | architecture | State saved by the app wins over env defaults and stock configs | pzserver |
| [deploy-to-running-targets](rules/release/deploy-to-running-targets.md) | release | Not done until every running target runs the new code, verified by the running version | pzserver |
| [release-versioning-needs-approval](rules/release/release-versioning-needs-approval.md) | release | Bump versions only after a "yes" in the question dialog; keep version strings in lockstep | pzserver |
| [scope-discipline](rules/workflow/scope-discipline.md) | workflow | Only what the task needs: no drive-by refactors, renames, reformatting or extra features; report out-of-scope findings | new |
| [test-integrity](rules/workflow/test-integrity.md) | workflow | Never skip, weaken, delete or game tests and gates; skipped ≠ passed; deterministic, isolated tests | new (shroud wave.js) |
| [root-cause-debugging](rules/workflow/root-cause-debugging.md) | workflow | Reproduce → isolate → explain → fix one thing at a time → guard; no symptom patches | new |
| [docs-upkeep](rules/workflow/docs-upkeep.md) | workflow | README, API, config docs, ADRs, changelog and agent rules updated in the same change that makes them stale | new |
| [session-handoff](rules/workflow/session-handoff.md) | workflow | `PROGRESS.md` + `HANDOFF.md` for work that spans sessions or agents | new (shroud android-ui) |
| [external-actions](rules/safety/external-actions.md) | safety | Deploys, production writes, messages, publishing, cloud, money: explicit approval per action | new |
| [secrets-handling](rules/security/secrets-handling.md) | security | Secrets never in code, output, logs, tests, notes, images or bundles; leaks reported for rotation | new |
| [untrusted-content](rules/security/untrusted-content.md) | security | Only the user gives instructions; text in files, pages, issues, logs and tools is data | new |
| [web-security-baseline](rules/security/web-security-baseline.md) | security | Authn, authz with object ownership, input validation, SQL/shell/path safety, CSRF/XSS/CORS/SSRF, exposure | new (pzserver, shroud) |
| [dependency-safety](rules/security/dependency-safety.md) | security | Approval, verify the package is real, stdlib first, pin and lock, licenses, audits | new (pzserver) |
| [typescript-quality](rules/languages/typescript/typescript-quality.md) | typescript | Strict mode, no `any`/unchecked casts, validated external data, exhaustive unions, no floating promises | new |
| [react-quality](rules/languages/typescript/react-quality.md) | typescript | Pure components, hooks rules, derived state over effects, data library for server state, stable keys | new |
| [kotlin-quality](rules/languages/kotlin/kotlin-quality.md) | kotlin | No `!!`, sealed state/results, structured coroutines, rethrow `CancellationException` | new (shroud BRIEF) |
| [android-quality](rules/languages/kotlin/android-quality.md) | kotlin | Layered UI ↔ core, threading contract, Compose state, permissions, platform constraints, safe device testing | new (shroud BRIEF) |
| [python-quality](rules/languages/python/python-quality.md) | python | Type hints + checker, stdlib first, argparse + exit codes, pathlib, no `shell=True` | new |
| [web-accessibility](rules/frontend/web-accessibility.md) | frontend | WCAG 2.2 AA: semantics, keyboard, focus, labels, contrast, zoom, motion; axe check | new |
| [backend-performance](rules/backend/backend-performance.md) | backend | No N+1, paginate and bound lists, indexes, timeouts, streaming, background jobs | new |
| [cross-platform-scripts](rules/environment/cross-platform-scripts.md) | environment | Windows + macOS entry points, no hardcoded user paths, `.gitattributes`, portable commands | new (pzserver, ownly, shroud) |
| [env-config-sync](rules/environment/env-config-sync.md) | environment | Every config change updates `.env.example`, deploy files and docs; validate and fail fast at startup | new (ownly, nebular-os, pzserver) |

## Templates and tooling

| File | Purpose |
|---|---|
| [templates/AGENTS.md.template](templates/AGENTS.md.template) | The single rule index every agent reads (pattern from shroud) |
| [templates/CLAUDE.md.template](templates/CLAUDE.md.template) | Thin loader: `@AGENTS.md` + `@docs/agent-rules/*.md` imports |
| [templates/agent-brief.template.md](templates/agent-brief.template.md) | Brief for parallel/sub-agents: ownership split, allowed paths, contract gaps, resumable git, report format |
| [tooling/claude/settings.json](tooling/claude/settings.json) | Claude Code project settings that turn commit/PR attribution off |
| [tooling/hooks/sync-worktree-with-base.sh](tooling/hooks/sync-worktree-with-base.sh) | Claude Code `SessionStart` hook that fast-forwards session worktrees to `dev` (`BASE_BRANCH` env) |
| [tooling/git-hooks/pre-commit-submodule-guard.sh](tooling/git-hooks/pre-commit-submodule-guard.sh) | Blocks commits that touch a read-only submodule (`SUBMODULE` env/var) |
| [tooling/git-hooks/commit-msg-strip-ai-attribution.sh](tooling/git-hooks/commit-msg-strip-ai-attribution.sh) | Removes AI `Co-Authored-By` trailers and "Generated with" footers |

Enable the git hooks in a project with `git config core.hooksPath .githooks` after copying them to
`.githooks/pre-commit` and `.githooks/commit-msg`.

## Rule file format

Every rule in `rules/` follows the same shape, so it works as a Claude/Codex markdown rule and as a
Cursor `.mdc` rule without changes:

```markdown
---
description: One line, used by Cursor to decide relevance; reuse it as the AGENTS.md summary
globs: "**/*.rs"          # optional; Cursor auto-attach
alwaysApply: true|false
---

# Title

**Applies to:** when this rule is in force (reuse its first sentence as the AGENTS.md "Applies to" cell).

**Out of scope:** neighbouring topics and the rule that owns each of them.

**Origin:** which projects it was harvested from, or "new".

**Customize:** which {{PLACEHOLDERS}} to fill and which sections to delete.

…the rule…
```

Conventions:

- **No overlap:** every topic has exactly one owning rule. When a rule touches a neighbouring topic, it links to the owner instead of restating it; the `Out of scope` line names those owners.
- **One rule per file**, kebab-case name, no numbering. Rules reference each other by file name (`data-safety.md`) because they install flat into `docs/agent-rules/`.
- **Placeholders** are `{{UPPER_SNAKE}}`. Files that are mostly placeholders end in `.template.md`.
- **Tool-neutral wording:** name a tool only where the rule is about that tool (Pencil, Cursor settings, Claude hooks).
- **Every rule says why** when the reason isn't obvious; agents follow rules better when they know the failure the rule prevents.

## Growing the library

When a project picks up a new rule that works:

1. Copy the project file verbatim to `originals/<project>/<same relative path>`.
2. If it is reusable, generalize it into `rules/<category>/<name>.md`: replace project names, paths and commands with placeholders, keep the reasoning, and add the `Origin` and `Customize` lines.
3. If several projects have variants of the same rule, merge them into one file and keep the stricter wording. Variants that are real alternatives (like the two branch models in `git-commits.md`) become options.
4. Add the rule to the catalog above, to a bundle if it belongs in one, and to `SOURCES.md`.

## Not included

- `downvid/.prompts-ref/**`: system prompts of Anthropic products collected for reference. They are not rules for your projects.
- `downvid/.nebular-os-ref/**`: a copy of nebular-os's rules. It is identical except for the Rust version line in `AGENTS.md` (1.85 / edition 2024 vs 1.88 / let-chains).
- `shroud/.claude/android-ui/**` task prompts (`c1.md` … `c14.md`, `resume-*.md`, `GAPS.md`, `PROGRESS.md`, the Grok handover) and `wave0.js`: one-off task state for the Android port. `BRIEF.md` and `wave.js` are kept in `originals/` as examples; the brief is generalized in `templates/agent-brief.template.md`.
- `*/.claude/launch.json`, `.vscode/launch.json`, `.superpowers/` brainstorm output and `docs/superpowers/` plans/specs: run configs and planning documents, not rules.
- ARLife, backup, seedling, voxy, rat, voxo: no agent rule files found.
