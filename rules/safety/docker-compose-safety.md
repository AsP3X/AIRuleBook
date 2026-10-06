---
description: Docker Compose safety — never remove volumes, never invent new compose variants, never rename containers or volumes without an explicit request
alwaysApply: true
---

# Docker Compose and database safety

**Applies to:** any Docker / Docker Compose operation and any change to `docker-compose*.yml`. Supplements `data-safety.md` — read both.

**Out of scope:** general data-loss rules (`data-safety.md`), pushing images or deploying (`external-actions.md`), env var documentation (`env-config-sync.md`).

**Origin:** `ownly` (`docker-compose-safety.mdc`).

**Customize:** fill in the compose file table, the safe stop script, and the confirm-destroy env var.

## Mandatory for agents

- **Never run `docker compose down -v`** (or `docker volume rm`) unless the user explicitly asks to destroy local database volumes and confirms data loss is acceptable.
- **Never assume** a dev Compose database volume is disposable. Users store real accounts and metadata there.
- Stop the stack with `{{SAFE_DOWN_SCRIPT}}` (no `-v`).
- If volume removal is truly required, require an explicit guard (e.g. `{{PROJECT}}_CONFIRM_DESTROY_DATA=yes {{SAFE_DOWN_SCRIPT}} --destroy-volumes`) **and** explicit user confirmation first.
- A `restart` does not rebuild an image. When the change lives in the image, rebuild and recreate: `docker compose up -d --build --force-recreate <service>`.

## Compose layout

| File | Purpose |
|------|---------|
| `docker-compose.yml` | {{DEFAULT_STACK_DESCRIPTION}} |

Environment-specific values belong in `.env` (gitignored), created from `.env.example`.

## Do not create new Compose variants

- **Never add** new `docker-compose*.yml` / `*.yaml` files unless the user explicitly asks for a named variant.
- Forbidden without request: staging, CI, test, override or per-environment compose files.
- Instead: change the existing file, use Compose **profiles**, or drive differences with **env vars**.
- Never rename `container_name` or volume identifiers without an explicit request (it orphans existing data).

## Production database

- Production uses a managed database (RDS, Cloud SQL, …) with backups and point-in-time recovery — not a Docker volume.

## Migrations

- Applied migrations are immutable; fix forward with new files (`sql-migrations-immutable.md`).
