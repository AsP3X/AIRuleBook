---
description: Reproduce, isolate and explain the root cause before changing code; one hypothesis at a time; fix the cause, not the symptom; guard it with a test
alwaysApply: true
---

# Root-cause debugging

**Applies to:** any bug report, failing test, failing build, crash, error message or unexpected behavior an agent investigates.

**Out of scope:** the guarding test's rules (`test-integrity.md`, `regression-testing.md`); destructive "reset" fixes (`data-safety.md`).

**Origin:** new (2026-10-05).

Do not change code to make an error go away until you can explain **why** it happens.

## 1. Reproduce

- Get a reliable reproduction first: the exact command, input, request or steps, and the exact error output.
- Read the **whole** error: message, stack trace, the first error in the log (not the last), exit code, and the relevant log lines before it.
- If you cannot reproduce it, say so and gather more evidence (logs, versions, environment, config) instead of guessing a fix.

## 2. Isolate

- Find where expected and actual behavior diverge: read the code path, add temporary logging, use a debugger, bisect inputs, or `git bisect` across commits when it used to work.
- Check what changed recently (`git log`, `git diff`, dependency or config changes, environment) — regressions usually live there.
- Verify assumptions with evidence: print the value, check the version, read the actual config that is loaded, inspect the running process — not the source you think is running.

## 3. Explain

- State the root cause in one or two sentences: *what* is wrong, *where* (file:line), and *why* it produces the symptom.
- Distinguish **cause** from **trigger** and **symptom**. A null-pointer crash is a symptom; the missing validation that let null in is the cause.

## 4. Fix

- Fix the cause at the right layer. Change **one thing at a time** and re-run the reproduction after each change.
- If a hypothesis is wrong, **revert** its change before trying the next one. Do not stack speculative edits.
- **Forbidden symptom patches:** catch-and-ignore, broad try/catch, null checks that hide a broken invariant, `sleep`/retry to hide a race, increasing timeouts without understanding the slowness, disabling the failing check, deleting state/caches/volumes to "make it work".
- Search for the **same bug pattern elsewhere** in the codebase; fix in scope or report the other occurrences (`scope-discipline.md`).

## 5. Guard and clean up

- Add a test that fails before the fix and passes after (`test-integrity.md`).
- Remove temporary debug logging, prints and breakpoints.
- Re-run the original reproduction and the relevant suite.

## When stuck

- After two or three failed hypotheses, **stop and report**: what you observed, what you ruled out and how, your current best hypothesis, and what evidence or access would settle it. Do not keep changing code at random.

## Report

Summarize: symptom → root cause (file:line) → fix → how verified → related occurrences found.
