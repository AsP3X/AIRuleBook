---
description: Repository layout — what each top-level path is for and where new code belongs (fill in per project)
alwaysApply: true
---

# {{PROJECT}} project layout

**Applies to:** deciding where any new file goes.

**Out of scope:** conventions for code inside those folders (`codebase-conventions.md`).

{{ONE_SENTENCE_WHAT_THE_PROJECT_IS}} (e.g. "a standalone, self-hosted object storage service (Rust/Axum) with an S3-like HTTP API, JWT auth, flat-file blobs and SQLite metadata").

## Directories

| Path | Role |
|------|------|
| `{{DIR}}/` | {{ROLE}} |
| `docs/` | Architecture decisions, protocol notes, API contracts |
| `docs/agent-rules/` | Agent rules (see `AGENTS.md`) |

## Where to implement

- **{{CONCERN}}** (e.g. HTTP API, auth, storage engine): `{{PATH}}`
- **Integration tests:** `{{TEST_PATH}}`
- Do **not** invent parallel top-level folders (`backend/` next to `server/`, `app/` or `mobile/` next to `ios/`).
- Do **not** assume another project's layout (state any sibling repos this one is often confused with).

## Local development

| Task | Command |
|------|---------|
| Build | |
| Test | |
| Lint | |
| Run (dev) | |

## Gotchas

<!-- Things that cost an agent time: required env vars and how to generate test tokens, tests that need/don't need a running server, pre-existing lint warnings that are not regressions, no hot reload, etc. -->

## Consumers

<!-- Other repos or clients that call this one, and the contracts they rely on. -->
