---
description: SQL migrations are immutable once applied; schema changes are new numbered files; fix checksum mismatches forward
globs: "**/migrations/**/*"
alwaysApply: true
---

# SQL migrations are immutable after apply

**Applies to:** every file under `{{MIGRATIONS_DIR}}` (e.g. `backend/migrations/postgres/`) and every schema change. Works for sqlx, Flyway, Prisma, Diesel, Alembic, Rails and any tool that checksums or tracks applied migrations.

**Out of scope:** query performance and indexes (`backend-performance.md`), destructive DB actions (`data-safety.md`).

The app runs migrations at startup. Editing an applied migration causes a checksum mismatch (sqlx: `migration N was previously applied but has been modified`) and the service exits before serving traffic.

## Rule

**Never edit a migration that has already been applied** — locally, in Docker, CI or production — **unless the user explicitly instructs you to edit that specific migration.** Schema changes after ship are a **new**, sequentially numbered file.

- **Do:** `ALTER TABLE …`, new tables, indexes, backfills and seeds in a new migration.
- **Do not:** change SQL in `001_…`, `002_…` after any environment ran them.

## Agent behavior

1. List `{{MIGRATIONS_DIR}}` and pick the **next** number.
2. Create a new file only; leave earlier migrations untouched.
3. If the user reports a checksum mismatch, explain the cause and recommend forward-fixing with a new migration, or resetting the **dev** database only with explicit permission (`data-safety.md`) — never rewriting applied history.
4. When schema semantics change, extend the migration backtest (empty DB + seeded previous-release dump) (`regression-testing.md`).

## Production

Never edit old migrations without an explicit ops plan; add a forward migration instead.
