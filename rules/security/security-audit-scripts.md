---
description: Conventions for standalone security audit/probe scripts — stdlib only, one finding per script, redaction by default, fixed exit codes, CI-friendly output
globs: "scripts/security-audit/**"
alwaysApply: false
---

# Security audit scripts

**Applies to:** files under `{{AUDIT_DIR}}` (e.g. `scripts/security-audit/`) — standalone scripts that probe a running deployment for known findings.

**Out of scope:** general Python rules (`python-quality.md`), the security requirements being probed (`web-security-baseline.md`).

**Customize:** `{{AUDIT_DIR}}`, `{{FINDINGS_DOC}}` (e.g. `security-audit.md`), ID prefix (`SEC-001`).

## Scope

- **Standalone only:** Python 3 stdlib; no imports from the application's code. The probe must not assume the repo layout (URL prefix comes from env/flags).
- **One finding per entry script** (e.g. `sec001_setup_info_disclosure.py`); shared code lives in `lib/`.
- Every script maps to an ID in `{{FINDINGS_DOC}}` (SEC-001, SEC-002, …).

## Layout

```
{{AUDIT_DIR}}/
  README.md
  Makefile
  sec00N_<short-name>.py        # thin entry: sys.path + lib main
  lib/
    constants.py models.py config.py http_client.py redact.py heuristics.py
    evidence.py report.py compare.py sarif.py runner_sec00N.py audit_main.py
  tests/
    test_*.py                   # unittest; no live server required
```

## Behavior

| Requirement | Detail |
|---|---|
| **Detection vs display** | Checks use raw HTTP bodies; **stdout redacts secrets by default**. Raw output only via an explicit flag **plus** an acknowledgement env var, and only in non-TTY CI. |
| **Exit codes** | `0` ok, `1` vulnerable, `2` inconclusive, `3` baseline drift. |
| **CLI** | `argparse`: `--base-url`, `--json`, `--sarif`, `--quiet`, `--strict`, `--retries`, `--fail-fast`, `--output-file`, baseline flags. |
| **Env** | `SEC00N_*` env vars mirror the flags for Compose/CI. |
| **Evidence** | Print an exploit payload once per endpoint; no duplicate leak blocks. |
| **Assertions** | Assert the safe state positively (expected 401/403/404/409 or redacted JSON), not only "no regex match". |
| **Remediation** | On FAIL, print a one-line hint pointing to the matching section of `{{FINDINGS_DOC}}`. |
| **Logs** | Remind operators to check that server/audit logs do not store secrets (the script cannot read the DB). |

## Adding a new audit (SEC-00N)

1. Add coverage in `lib/runner_sec00N.py` and labels/routes in `constants.py`.
2. Add the thin `sec00N_*.py` entry script.
3. Add unit tests for redaction/heuristics that run without a server.
4. Document it in the audit `README.md`.
5. Update the verification checkboxes in `{{FINDINGS_DOC}}`.

## Do not

- Commit live credentials, or baselines containing raw secrets.
- Disable redaction by default.
- Import application code.
