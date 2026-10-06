---
description: Developer scripts and tooling work on Windows and macOS/Linux — paired entry points, no hardcoded user paths, .gitattributes line endings, portable commands
alwaysApply: true
---

# Cross-platform scripts and tooling

**Applies to:** every script, Makefile target, hook, task runner entry, Docker bind mount and documented command that a developer or agent runs on their machine — in a project developed on both Windows and macOS/Linux.

**Out of scope:** Python script internals (`python-quality.md`), npm lockfiles for Docker (`npm-lockfile-linux-docker.md`), env var documentation (`env-config-sync.md`).

**Customize:** `{{PLATFORMS}}` (e.g. Windows 11 + PowerShell 5.1/7, macOS + zsh/bash, Linux CI).

## Entry points

- Every developer-facing command has a way to run it on **each** supported platform. Pick one pattern per project and follow it:
  - **Paired scripts:** `scripts/x.sh` + `scripts/x.ps1` with the same name, flags and behavior. Changing one means changing the other in the same change set.
  - **One portable runtime:** a Node/Python/Go script invoked the same way everywhere (`node scripts/x.mjs`, `python scripts/x.py`).
  - **Task runner:** `make` + `make.ps1`, or a cross-platform runner (`just`, `task`, npm scripts that call portable code).
- Bash scripts assume **Git Bash** on Windows at most — no GNU-only flags without a fallback (`sed -i` differs on macOS, `readlink -f`, `date -d`), no `/proc`.
- PowerShell scripts work on Windows PowerShell 5.1 unless the project requires 7+ (no `&&`/`||`, ternary or `??` in 5.1). Pass `-Encoding utf8` when writing files.

## Paths

- **Never hardcode user-specific or machine-specific paths** (`/Users/<name>/…`, `C:\Users\<name>\…`, `/opt/homebrew/…`) in committed scripts, configs, rules or docs. Derive from the repo root (`$(git rev-parse --show-toplevel)`, `$PSScriptRoot`, `__dirname`, `Path(__file__)`), `$HOME`, or an env var with a documented default.
- Build paths with the language's path API, not string concatenation with `/` or `\`.
- Quote every path (spaces in `Documents\development` etc.). Watch Windows' 260-char path limit for deep temp/build dirs.
- Docker bind mounts: document both forms when they differ (`./frontend:/app` vs `C:/path/frontend:/app`).

## Line endings and file modes

- `.gitattributes` defines line endings: `* text=auto`, `*.sh text eol=lf`, `*.ps1 text eol=crlf`, binary types as `binary`. Shell scripts with CRLF break in containers.
- Executable bits: `git update-index --chmod=+x script.sh` (Windows checkouts don't keep `chmod`).
- Text files are UTF-8 (no BOM for shell scripts).

## Commands in docs and rules

- When documenting a command that differs per platform, show each variant, labeled.
- Don't assume tools that are not installed by default (`jq`, `rsync`, `gsed`, `make` on Windows) — check for them and print an install hint, or use a portable alternative.

## Verify

- Run a changed script on the platform you are on; for the other platform, at least lint it (`shellcheck`, `bash -n`, PowerShell parser) and state that it was not executed there.
