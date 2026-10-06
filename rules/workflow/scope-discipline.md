---
description: Change only what the task requires — no drive-by refactors, renames, reformatting or unrequested features; report out-of-scope findings instead of fixing them
alwaysApply: true
---

# Scope discipline

**Applies to:** every change an agent makes to the repository.

**Out of scope:** *how* to change code well (`codebase-conventions.md`), adding packages (`dependency-safety.md`), what to test (`regression-testing.md`).

**Origin:** new (2026-10-05) — the most common agent failure mode; not harvested from a project.

The diff is the deliverable. Every line in it must be explainable by the task. A reviewer should be able to read the diff and see only the requested change.

## The task defines the scope

- Do what was asked — **all of it, and nothing else**.
- If the request is ambiguous about scope (one screen or every screen? this endpoint or the whole API?), **ask** before widening it. Do not pick the bigger interpretation to be thorough.
- If the task can only be done well by touching something outside its obvious scope (a shared helper, a type used elsewhere), make that change, keep it minimal, and **name it** in the summary.

## Do not, unless the task asks for it

- **Refactor** code you are not otherwise changing — extracting helpers, restructuring modules, converting styles (callbacks → async, class → function components).
- **Rename** files, symbols, routes, env vars, DB columns or CSS classes.
- **Reformat** code you did not change: no whole-file formatter runs, import re-sorting, quote/semicolon/whitespace churn. If the project's formatter reformats untouched lines on save, revert those hunks.
- **Add features**, options, flags, config switches, "while I'm here" improvements, or speculative extension points.
- **Change behavior** on paths the task doesn't cover — default values, error messages, timeouts, log levels, ordering.
- **Upgrade or swap** dependencies, toolchains, CI config or linters.
- **Delete** code, comments, tests or files you believe are unused — report them instead.
- **Touch generated files** by hand (lockfiles, codegen output, migrations snapshots) except by running the generator the task requires.

## Minimal diff

- Prefer the smallest change that fully solves the task and matches existing patterns.
- Keep the surrounding code's style even if you would write it differently.
- One task, one coherent change set. If you notice you need two unrelated changes, stop and say so.

## Out-of-scope findings

When you notice something worth fixing outside the task — a bug, dead code, a stale doc, a security issue, a flaky test:

1. **Don't fix it** in this change.
2. **Report it** at the end under a short "Noticed, not changed" list: file:line, what is wrong, why it matters, suggested fix.
3. **Exception:** if the issue *blocks* the task (the task cannot work without it) or is a **security issue actively exposed** by your change, fix the minimum needed and call it out explicitly.

## Self-check before reporting done

- Read your full diff. For each hunk ask: "Would the task fail or be incomplete without this?" If not, remove it.
- No file is in the diff that the summary does not mention.
- Whitespace-only and formatting-only hunks are gone.
