---
description: Runtime state written by the app (admin panel, DB rows, state files) is authoritative; env defaults and stock configs only seed a first boot
alwaysApply: true
---

# The app's saved state is the single source of truth

**Applies to:** projects where an admin UI/panel (or the app itself) writes configuration that is also seeded from `.env`, stock config files, package managers or downloads.

**Out of scope:** documenting env vars and config validation (`env-config-sync.md`).

**Origin:** `pzserver` (`AGENTS.md` → "The UI panel is the single point of truth").

**Customize:** list the authoritative stores in the table.

The {{AUTHORITY}} (e.g. the admin web panel) is the source of truth for how the system is configured. `.env`, installer defaults, stock config files and downloaded content are **bootstraps or caches** — never the authority once the {{AUTHORITY}} has written a value.

**What the {{AUTHORITY}} last saved wins.**

| Concern | Authoritative store | Seed only |
|---|---|---|
| {{CONCERN}} (e.g. mods list) | {{STORE}} (e.g. `data/.../.mod_state`) | {{SEED}} (e.g. `MOD_IDS` env on first boot) |
| {{CONCERN}} (e.g. server settings) | {{STORE}} (e.g. `.config_state`) | stock `server.ini` |
| {{CONCERN}} (e.g. site copy, shop) | database rows | JSON defaults |

## Rules

- Do not "fix" a missing setting or list by writing `.env` defaults over the authoritative store.
- Do not delete authoritative state files on a reset/wipe of *other* data.
- After a wipe or restore, **re-apply the saved state** — do not regenerate a stock config and hope env or a download fills it in.
- Startup/configure scripts must keep treating the authoritative store as the winner; do not regress that ordering.
