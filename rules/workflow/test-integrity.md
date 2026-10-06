---
description: Tests and checks are evidence — never weaken, skip, delete or game them to get green; tests must be deterministic and actually exercise the code
alwaysApply: true
---

# Test integrity

**Applies to:** every test, assertion, CI job, lint gate and check command an agent runs, writes or edits.

**Out of scope:** *what* to test for a given change (`regression-testing.md`), what evidence to report (`definition-of-done.md`), how to find the cause of a failure (`root-cause-debugging.md`).

A green check is only worth something if it would have gone red on a broken change. Making a check pass without making the code correct is **worse than reporting the failure**.

## Never do this to make a check pass

- **Delete, comment out, skip or `xfail`** a failing test (`#[ignore]`, `it.skip`, `@Disabled`, `@pytest.mark.skip`, `XCTSkip`).
- **Weaken an assertion**: loosen equality to "not null", widen tolerances, assert on the wrong field, catch and swallow the exception the test expects, replace an exact expected value with whatever the code now returns (unless the task changed that behavior on purpose — then say so).
- **Mock the unit under test**, or mock so much that the test only checks the mock.
- **Special-case test inputs** in production code (`if (env == "test")`, detecting fixture values, hardcoding the expected answer).
- **Disable or bypass gates**: `|| true`, `continue-on-error`, `--no-verify`, lowering coverage thresholds, removing a CI step, adding lint suppressions (`#[allow]`, `eslint-disable`, `@Suppress`, `# type: ignore`, `// @ts-expect-error`) to silence a real finding.
- **Update snapshots/golden files blindly**: only regenerate after inspecting the diff and confirming the new output is the intended behavior.
- **Retry until green**: re-running a failing test until it passes is not a fix.

If a test is genuinely wrong (it encodes outdated behavior the task deliberately changes), update it **and** state in the summary which test changed and why.

## Checks must actually run

- A "skipped" test is not a pass. Check the runner output for skipped/ignored counts, and for tests that silently skip when a dependency (DB, network, simulator) is missing. Report skips explicitly.
- Confirm the test you wrote **fails without your fix** (run it before the fix, or temporarily revert) — otherwise it guards nothing.
- Run the **real** command the project uses (Makefile/CI target), not a narrower one, before claiming the suite is green. Narrow runs are fine while iterating.
- An exit code of 0 is not always success (some runners exit 0 on failure); read the summary line.

## Tests must be trustworthy

- **Deterministic:** no dependence on wall-clock time, timezones, locale, random seeds, test order, or real network. Inject clocks and seeds; use fakes for external services.
- **No sleeps for synchronization**: wait on a condition/event with a timeout, never `sleep(2)`.
- **Isolated:** each test sets up and tears down its own data; no shared mutable state between tests; throwaway databases/containers on their own ports, never the developer's dev data.
- **Readable:** name says the behavior (`returns_404_when_bucket_missing`), arrange/act/assert are visible, one behavior per test.
- **Test vectors** for ported or protocol behavior come from the reference implementation or spec, not from running the new code.

## Flaky tests

- A flaky test is a bug. Do not quarantine or retry-wrap it silently. Report it with the failure output and suspected cause; fix it if it is in scope.

## Reporting

- Report exact counts (passed / failed / skipped) and any check you could not run, with the reason and the command the user should run.
