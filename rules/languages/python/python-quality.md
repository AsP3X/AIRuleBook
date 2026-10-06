---
description: Python quality bar — type hints checked by a type checker, stdlib first, argparse CLIs with exit codes, explicit errors, pathlib, subprocess without shell, deterministic tests
globs: "**/*.py"
alwaysApply: false
---

# Python quality

**Applies to:** all Python code — scripts, tooling, audit probes, services and tests.

**Out of scope:** security probe script conventions (`security-audit-scripts.md`), packages (`dependency-safety.md`), cross-platform script behavior (`cross-platform-scripts.md`).

## Version and environment

- Target the project's Python version ({{PYTHON_VERSION}}, e.g. 3.11+); don't use newer syntax than that.
- Use the project's environment tool (venv / uv / poetry) — never install packages into the global interpreter.
- **Standard library first.** Scripts meant to run anywhere (CI, containers, other people's machines) stay stdlib-only unless the user approves a dependency.

## Types

- Type hints on all function signatures and module-level values; `from __future__ import annotations` where it helps.
- Use `dataclass(frozen=True)` / `NamedTuple` / `TypedDict` for structured data — not loose dicts passed around.
- `Enum` / `Literal` for closed sets.
- The project's type checker (mypy / pyright) passes on changed files with no new `# type: ignore` (if unavoidable: `# type: ignore[code]  # reason`).

## Errors

- Never bare `except:` or `except Exception: pass`. Catch specific exceptions; re-raise with context (`raise X(...) from e`).
- No `assert` for runtime validation (stripped with `-O`); raise a proper exception.
- Fail loudly with a clear message on invalid input or config.

## CLI scripts

- Entry point is `def main(argv: list[str] | None = None) -> int:` guarded by `if __name__ == "__main__": sys.exit(main())`.
- Arguments via `argparse` with `--help` text; env vars may mirror flags for CI.
- **Defined exit codes** (`0` success, non-zero documented per failure class); errors to `stderr`, results to `stdout`; offer `--json` for machine-readable output when results are consumed by tools.
- No interactive prompts unless a TTY is present and a flag allows them.

## I/O, paths, processes

- `pathlib.Path` for paths; never build paths with string concatenation or hardcoded separators.
- Always pass `encoding="utf-8"` to `open()` / `read_text()` / `write_text()`.
- Use context managers (`with`) for files, sockets and locks.
- `subprocess.run([...], check=True)` with an **argument list** — never `shell=True` with interpolated input.
- HTTP: timeouts on every request; retries with backoff only for idempotent calls.

## Style

- Formatter and linter per project (ruff/black); no new lint suppressions.
- `logging` (with a module logger) for diagnostics, not `print`, in libraries and services. Never log secrets (`secrets-handling.md`).
- No mutable default arguments; no wildcard imports; no module-level side effects beyond constants.

## Tests

- `unittest` or `pytest` as the project uses; tests run without network or a live server unless they are explicitly integration tests.
- Deterministic: inject time and randomness; use `tmp_path` / `tempfile` for files (`test-integrity.md`).

## Before "done"

- Formatter, linter, type checker and tests pass; the script's `--help` works.
