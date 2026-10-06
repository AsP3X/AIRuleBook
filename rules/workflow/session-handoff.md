---
description: Long or multi-session agent work keeps a progress file and leaves a handoff note so the next session (or agent) can resume without guessing
alwaysApply: false
---

# Session handoff for long-running work

**Applies to:** work that spans more than one agent session — long tasks that may hit context or usage limits, multi-step plans, autonomous runs, and work passed between agents (Claude ↔ Cursor ↔ Codex ↔ Grok).

**Out of scope:** plan structure (`plan-execution.md`); committing work in progress (`git-commits.md` — autonomous briefs may allow "commit early and often"); multi-agent briefs (`templates/agent-brief.template.md`).

**Customize:** `{{HANDOFF_DIR}}` (e.g. `.agent-notes/` or `docs/handoff/`), and whether it is committed or git-ignored.

A session can end at any moment. Anything that lives only in the conversation is lost.

## Progress file

For work that will clearly outlast one session, keep `{{HANDOFF_DIR}}/<task-slug>/PROGRESS.md` and update it **after every meaningful step** (not only at the end):

```markdown
# <Task title>
Goal: <one sentence>   Plan: <path to plan, if any>
Branch / worktree: <name> @ <short sha>

## Done
- [x] Step 1 — <what, where> (verified: <command → result>)

## In progress
- [ ] Step 3 — <exact state: what is half-done, which files>

## Next
- [ ] Step 4 …

## Decisions
- <decision> — because <reason> (asked user? yes/no)

## Open questions / blockers
- <question for the user, or what is blocking and how to unblock>

## Gotchas
- <non-obvious things learned: commands that fail and why, env quirks, wrong leads already ruled out>
```

## Handoff note

When stopping before the task is complete (or when handing to another agent), write `HANDOFF.md` next to the progress file:

- **State:** what works, what is broken right now, what is uncommitted.
- **How to verify:** the exact commands and expected results.
- **Resume here:** the single next action, with file paths.
- **Do not:** traps the next session must avoid (wrong approaches already tried, files owned by someone else, protected resources).

Write for a reader with **zero context** — no "as discussed", no references to the conversation.

## Resuming

- Read `PROGRESS.md` and `HANDOFF.md` **first**, then verify the claimed state (run the verification commands, check `git status` and the branch) before continuing. Notes can be stale.
- If the base branch moved, catch up first (`worktrees-from-base-branch.md`).

## Hygiene

- Never put secrets, tokens or personal data in notes (`secrets-handling.md`).
- When the task is finished, delete the notes or fold durable knowledge (gotchas, decisions) into proper docs (`docs-upkeep.md`).
