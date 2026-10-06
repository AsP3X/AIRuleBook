---
description: Every new or changed mutation and security-sensitive action writes a semantic audit log entry (or is explicitly exempt)
alwaysApply: true
---

# Audit log coverage (mandatory review)

**Applies to:** any change to backend routes, auth, permissions or admin tools.

**Out of scope:** access control itself (`web-security-baseline.md`), application/debug logging (`api-error-envelope.md`).

**Customize:** `{{AUDIT_FN}}` (e.g. `audit::write_audit` in `backend/src/audit.rs`), `{{AUDIT_TABLE}}` (e.g. `audit_logs`).

Semantic user and admin actions must appear in `{{AUDIT_TABLE}}`. Raw HTTP/access logs are **not** a substitute.

## When you must add or update audit logging

Treat every **new or changed** API behavior as an audit candidate if it:

- **Creates, updates, deletes or archives** data
- **Changes auth or sessions** (login, logout, register, password reset)
- **Changes permissions, roles, groups or admin settings**
- **Runs privileged admin tools** (kick, ban, wipe, restart, raw console commands)

**Usually exempt:** read-only GET/list/detail endpoints; pure tracing/metrics.

If unsure, **add the audit entry** — missing rows are hard to fix in production.

## How to implement

Use `{{AUDIT_FN}}`:

- Pass request headers when available so IP and User-Agent are captured.
- Use dotted action names: `auth.login`, `files.upload`, `files.delete`, `admin.player.ban`.
- Set `resource_type` and `resource_id` to the primary entity.
- **Never** put secrets, passwords or tokens in the context payload.

## Agent checklist (before "done")

When the diff touches backend routes or auth:

1. List every **new or modified mutation**.
2. For each, confirm the audit entry was **added** or is **intentionally exempt** (say why).
3. Mention audit coverage in the completion summary.
