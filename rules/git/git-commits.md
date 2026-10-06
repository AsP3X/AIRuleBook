---
description: Git commits only on explicit user request; TASK/FIX/BUGFIX/DOCS/CHORE message format; branch model; staging scope, secrets, hooks, push and merge limits
alwaysApply: true
---

# Git commits

**Applies to:** every git action an agent takes in the repository.

**Out of scope:** secrets in diffs and leaks (`secrets-handling.md`), AI credit lines (`no-ai-attribution.md`), worktree setup (`worktrees-from-base-branch.md`), other outward actions such as deploys or PR comments (`external-actions.md`).

**Origin:** `nebular-os` (full version), `ownly`, `shroud` (short versions with the dev branch model) — merged.

**Customize:** pick one branch model below and delete the other; set `{{DEFAULT_BRANCH}}` / `{{INTEGRATION_BRANCH}}`; extend the "never commit" artifact list for your stack.

## Enforcement (strict)

- This rule is **mandatory** for every agent-authored git action.
- If a git command would violate any section below, **do not run it**. Stop, explain the exact conflict, and ask the user for explicit confirmation or clarification.
- When several instructions apply, prefer the **most restrictive** reading that keeps history safe and intentional.

## When commits are allowed

- **Commit only when the user explicitly asks** ("commit this", "make a commit"). "Save my work" or "checkpoint" count only when they clearly mean a git commit — when in doubt, **ask**.
- **Never** commit to "helpfully" save progress, to finish a task, or because the change set feels done.
- **Never** amend, rebase, squash or otherwise rewrite history unless explicitly asked.
- **Never** `git push` (and never force-push) unless explicitly asked to push.
- **Never** merge or rebase branches unless explicitly asked.

> Exception for long-running autonomous agents working in their **own** branch/worktree: the task brief may instruct "commit early and often" so interrupted work is not lost. That instruction must come from the user or the brief, never be assumed. See `templates/agent-brief.template.md`.

## Branch model

### Option A — trunk + feature branches

| Branch | Role |
|--------|------|
| `{{DEFAULT_BRANCH}}` (e.g. `master`/`main`) | Integration and release line. Receives feature work via pull request. |
| `feat/<name>` / `feature/<name>` | Feature work, branched from an up-to-date `{{DEFAULT_BRANCH}}`. |

Flow: `feat/...` → `{{DEFAULT_BRANCH}}` via pull request.

### Option B — dev integration branch

| Branch | Role |
|--------|------|
| `{{DEFAULT_BRANCH}}` (e.g. `master`) | Release line. Stable, production-ready history. |
| `{{INTEGRATION_BRANCH}}` (e.g. `dev`) | Integration branch; collects finished feature work. |
| `feature/<name>` | Feature work, branched from an up-to-date `{{INTEGRATION_BRANCH}}`. |

Flow: `feature/...` → `{{INTEGRATION_BRANCH}}` → `{{DEFAULT_BRANCH}}` via pull requests. Pair with `worktrees-from-base-branch.md`.

### Agent defaults

- When asked for a new branch, create `feat/<short-descriptive-slug>` (or the user's pattern: `fix/...`, `chore/...`) from the up-to-date base branch.
- Prefer finishing work through a **pull request**. Do not suggest a local `checkout <base> && merge` as the normal path; do it only when the user explicitly asks.
- Recommend branch protection on the release branch (require PR, reviews, status checks).

## Staging scope

- **Stage only** the paths the user named, or changes that clearly belong to the requested commit.
- If other files are modified or untracked, **list them** and leave them unstaged or ask. Never `git add -A` / `git add .` unless the user asked to commit **everything**.
- Run `git status` before committing so staged vs. unstaged is intentional.
- Binary/design files must be committed together with the assets they reference.

## One logical change per commit

- One coherent story per commit. If the tree mixes unrelated work (a bug fix and a docs refresh), tell the user and offer **split commits**, or ask which single prefix and scope they want.

## Never commit

- **Secrets:** API keys, passwords, tokens, private keys, full `.env` files. If they appear staged or in a diff, **stop**, warn the user, and unstage them first. An already-committed secret is a leak — follow `secrets-handling.md`.
- **Generated or ignored artifacts:** anything in `.gitignore` (e.g. `target/`, `node_modules/`, `dist/`, `build/`, `DerivedData/`, `*.db`, coverage output) unless the user explicitly wants it tracked.

## Hooks

- Never bypass hooks with `--no-verify` / `-n` unless the user explicitly asks for that commit.

## Commit message structure (required)

Every agent-authored commit with a custom message:

1. **First line:** exactly one prefix below, a colon, a space, then a short summary (about 72 characters or fewer).
2. **Blank line**, then an optional **body** (what changed, why; how for fixes). Trivial changes stay short; non-trivial ones get a fuller body.

| Prefix | Use for |
|--------|---------|
| `TASK: ` | New work or refactors — behavior, structure, features. |
| `FIX: ` | A regression caused by an **earlier intentional change** (bad assumption, incomplete follow-up). |
| `BUGFIX: ` | A **pre-existing** bug — incorrect behavior not introduced by the immediately previous change. |
| `DOCS: ` | Documentation only (README, guides). Inline comments that accompany code go with `TASK:`. |
| `CHORE: ` | Tooling and maintenance only: CI, `.gitignore`, agent/editor config, formatting config, dependency bumps. |

Merge and revert commits may keep Git's default message.

### Which prefix?

- Only docs changed → `DOCS:`
- Only CI / ignore rules / config housekeeping → `CHORE:`
- Regression from the last intentional change → `FIX:`
- Pre-existing wrong behavior → `BUGFIX:`
- Feature, refactor or product change → `TASK:`
- Mixed unrelated edits → split, or ask.

### Examples

```text
TASK: Add bucket existence check before list_objects.

Returns 404 JSON when the metadata DB has no rows for the bucket prefix.
```

```text
BUGFIX: Range request returns 500 when end offset equals file size.

Clamp end to size - 1; add an integration test.
```

## No AI attribution

Commits carry only the human author — see `no-ai-attribution.md`.

## Summary

1. No commit / push / merge / rebase / amend without an explicit request.
2. Branch from the up-to-date base; finish via pull request.
3. Stage only what belongs; surface unrelated dirty files.
4. One logical change per commit.
5. No secrets, no ignored or generated artifacts.
6. No `--no-verify` unless asked.
7. Prefix every custom message with `TASK:`, `FIX:`, `BUGFIX:`, `DOCS:` or `CHORE:`.
