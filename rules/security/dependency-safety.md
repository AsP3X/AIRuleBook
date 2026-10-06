---
description: Adding, upgrading or removing third-party packages — approval first, verify the package is real and healthy, prefer the standard library, pin versions, commit lockfiles, check licenses
alwaysApply: true
---

# Dependency safety

**Applies to:** adding, upgrading, replacing or removing any third-party package, crate, pod, gem, Gradle/Maven artifact, Docker base image, GitHub Action, or vendored code — in any manifest (`package.json`, `Cargo.toml`, `pyproject.toml`/`requirements*.txt`, `build.gradle*`, `Package.swift`, `Podfile`, `go.mod`, `Dockerfile`, CI workflows).

**Out of scope:** Linux-complete npm lockfiles for Docker (`npm-lockfile-linux-docker.md`); read-only submodules (`vendored-submodule-readonly.md`); deprecated APIs inside existing deps (`no-deprecated-apis.md`).

**Origin:** new (2026-10-05); expands the "do not change dependencies without approval" line from pzserver's `CLAUDE.md`.

## Approval

- **Ask before adding** a new dependency or doing a **major** upgrade. Say what it is for, why the standard library or an existing dependency is not enough, its size, and its license.
- Patch/minor upgrades only when the task needs them (bug or security fix) — no opportunistic bulk upgrades (`scope-discipline.md`).

## Prefer not adding one

- Use the standard library or a dependency the project already has first.
- Don't add a package for a few lines of code (left-pad, is-odd, a tiny helper). Write it, with a test.
- One library per job: don't add a second HTTP client, date library, state manager or test framework next to the existing one.

## Verify the package is real and the right one

Agents hallucinate package names, and attackers register those names (slopsquatting / typosquatting).

- Confirm the **exact name** on the official registry (npmjs.com, crates.io, PyPI, Maven Central, Swift Package Index), and that it is the package the docs refer to — check the publisher/org and repository link.
- Check health signals: maintained (recent releases), real download numbers, an active source repo, no open critical advisories, no unexplained ownership transfer.
- Be suspicious of: names one character off a popular package, brand-new packages with few downloads, packages with `postinstall`/build scripts that fetch or execute remote code.

## Pin and lock

- Commit the lockfile (`package-lock.json`, `Cargo.lock` for binaries, `poetry.lock`/`uv.lock`, `Package.resolved`, `gradle.lockfile` where used). Use the lockfile-respecting install in CI (`npm ci`, `cargo build --locked`, `uv sync --frozen`).
- Use the project's version-range convention; never `*` or `latest`.
- Pin Docker base images to a specific tag (ideally a digest), and GitHub Actions to a release tag or commit SHA.
- Install with the project's package manager only (don't mix npm/yarn/pnpm; don't hand-edit lockfiles).

## Licenses

- Check the license is compatible with the project's ({{PROJECT_LICENSE}}). Flag copyleft (GPL/AGPL), "non-commercial", source-available, or missing licenses to the user before adding.

## Security

- Run the ecosystem's audit after changes where available (`npm audit`, `cargo audit`/`cargo deny`, `pip-audit`, `osv-scanner`) and report new findings.
- Don't disable audit findings to get green (`test-integrity.md`).

## Removing

- Remove a dependency only when the task requires it or the user asks; remove its imports, config and lockfile entries together.

## Report

For every dependency change, list: package, old → new version, why, license, and audit result.
