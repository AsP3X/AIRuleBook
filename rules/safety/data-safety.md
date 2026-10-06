---
description: Forbid destructive or data-loss actions (volumes, databases, migrations, bulk deletes, history rewrites) without explicit user permission
alwaysApply: true
---

# Data safety (mandatory)

**Applies to:** every command an agent runs, recommends or chains.

**Out of scope:** actions on remote, shared or production systems (`external-actions.md`), Docker specifics (`docker-compose-safety.md`), secret leaks (`secrets-handling.md`).

**Origin:** `ownly`, `shroud` (`data-safety.mdc`) — merged.

**Customize:** add your project's safe stop script (e.g. `scripts/compose-dev-down.sh`) and any irreplaceable files (design files, asset folders) to the lists below.

**Do not run, recommend, or chain commands that can destroy, wipe, or irreversibly alter user data** unless the user **clearly and explicitly** asked for that specific destructive outcome in the current request.

When in doubt, **stop**, explain the risk, and ask.

## What counts as explicit permission

The user must **name the destructive action** or clearly accept data loss:

- "Run `docker compose down -v`"
- "Wipe the local Postgres volume"
- "Drop this table / truncate the database"
- "Delete all rows in …"
- "Force-push and overwrite remote history"

**Not sufficient on their own:** "fix it", "clean up", "reset", "start fresh", "make it work", or carrying on because a previous step failed. Treat those as **non-destructive** troubleshooting until the user confirms data loss is OK.

## Forbidden without explicit permission

### Containers, volumes and databases

- `docker compose down -v`, `docker volume rm`, `docker system prune` (especially with volumes)
- Dropping or recreating database data directories or volumes
- Editing already-applied SQL migrations or rewriting migration history (`sql-migrations-immutable.md`)
- `DROP DATABASE`, `TRUNCATE`, bulk `DELETE`/`UPDATE` without a scoped `WHERE`

Prefer: a stop script without `-v`, read-only inspection, a backup first, a **new** migration instead of editing an old one.

### Files and repositories

- `rm -rf` on project trees, home paths, or anything outside clearly disposable temp/cache dirs
- Mass deletion of files the user did not name
- Deleting or overwriting irreplaceable assets: {{IRREPLACEABLE_FILES}} (e.g. design source files and the asset folders they reference)
- `git reset --hard`, `git clean -fdx`, force-push, history rewrites — follow `git-commits.md`; ask when intent is unclear

### Production and shared environments

- Never assume dev volumes or local databases are disposable; users keep important data there.
- Never run destructive fixes against production or shared databases without explicit approval.

## When blocked

1. State **what** would be destroyed or changed.
2. Offer **non-destructive** next steps (logs, read-only checks, backup, new migration).
3. Ask the user to confirm explicitly if they want the destructive path.
