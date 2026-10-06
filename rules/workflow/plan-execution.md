---
description: Follow implementation plans step by step as a binding checklist; verify and loop until every item is done
alwaysApply: true
---

# Plan execution and completion

**Applies to:** any task that comes with a plan (a plan file such as `.cursor/plans/`, `docs/plans/`, or a plan pasted in chat).

**Out of scope:** what counts as evidence (`definition-of-done.md`), not widening a plan (`scope-discipline.md`), multi-session plans (`session-handoff.md`).

**Origin:** `nebular-os`, `ownly` (`plan-execution.mdc`) — merged.

**Customize:** list your project's check commands in the Verification section.

Treat the plan as a **binding checklist**, not a loose outline.

## Execution

- **Work in order** unless the plan explicitly allows parallel tracks or reordering. Do not skip, merge or "mostly" complete steps.
- **Cover every item:** every step, sub-step, file, migration, test and doc change the plan names is done — or explicitly called out as blocked, with the blocker and what is needed to unblock it. Never omit work silently.
- **One pass is not enough** if anything failed or was deferred: loop back and finish the remaining items before declaring the task done.

## Verification

- After substantive changes, **run the relevant checks** ({{CHECK_COMMANDS}}, e.g. `cargo test`, `cargo clippy`, `npm run build`, a Docker smoke test). Fix failures **before** stopping.
- Confirm behavior matches the plan's **intent**, not only that the code compiles: if the plan describes HTTP, storage or UI behavior, verify it through tests and/or a manual smoke path.

## Done criteria

Do not say the work is complete until:

1. Every plan step is addressed (implemented, tested as specified, or explicitly blocked with a reason).
2. The checks you ran are **green** — or you report the exact failing command.
3. Nothing material from the plan was left implied but unimplemented.

This rule exists because partial execution of plans has caused missed steps and broken states in the past.
