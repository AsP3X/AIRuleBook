---
description: Git worktrees start from an up-to-date integration branch and are caught up again before testing and merging back
alwaysApply: true
---

# Worktrees start from an up-to-date base branch

**Applies to:** every git worktree an agent creates or works in, including worktrees a tool or app creates for a session. Use with branch model B in `git-commits.md`.

**Out of scope:** when to commit, push or merge (`git-commits.md`).

**Origin:** `shroud` (`docs/agent-rules/worktrees-from-dev.md`).

**Customize:** `{{BASE}}` = the branch active work happens on (e.g. `dev`). Optional: install `tooling/hooks/sync-worktree-with-base.sh` as a Claude Code `SessionStart` hook.

`{{BASE}}` is the working branch; the release branch can lag it by many commits. A worktree based on anything older than the current `{{BASE}}` edits stale code and conflicts on merge.

## Creating a worktree

Base it on `{{BASE}}` — never on the release branch, another feature branch or a detached commit — and bring it level with `origin/{{BASE}}` before the first edit:

1. `git fetch origin`
2. `git worktree add -b <branch> <path> {{BASE}}`
3. In the worktree: `git merge --ff-only origin/{{BASE}}` (picks up commits pushed from elsewhere that local `{{BASE}}` lacks).

If step 3 cannot fast-forward, local `{{BASE}}` and `origin/{{BASE}}` have diverged. **Stop and tell the user**; do not merge, rebase or reset either branch to settle it.

## Worktrees made for you

A session worktree created by a tool may start on the release branch or an older commit. Before the first edit:

1. `git fetch origin`
2. `git merge --ff-only {{BASE}}`, then `git merge --ff-only origin/{{BASE}}`.

Both are no-ops when already current. If the worktree already carries its own commits, merge `{{BASE}}` into it instead of fast-forwarding and resolve conflicts.

## Staying up to date

Other sessions keep landing commits on `{{BASE}}`. Catch the worktree up again — same fetch and merge — **before you build or test for the final result**, and **before merging the branch back**. Never merge a worktree branch into `{{BASE}}` while it is behind `{{BASE}}`.
