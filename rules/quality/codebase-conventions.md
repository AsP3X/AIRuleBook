---
description: Follow existing conventions, reuse before writing, keep the directory layout, and ask before adding dependencies or base folders
alwaysApply: true
---

# Codebase conventions

**Applies to:** every code change.

**Out of scope:** staying inside the task (`scope-discipline.md`), adding packages (`dependency-safety.md`), language-specific rules (`languages/`).

**Origin:** `pzserver` (`CLAUDE.md` → General), `shroud`/`nebular-os` (`project-layout.mdc`), `pzserver` design constraints — merged and generalized.

## Fit in

- **Follow existing conventions.** Before writing a new file, read its siblings and match their structure, naming, error handling and comment style.
- **Reuse before writing.** Search for an existing component, helper or service first; extend it rather than adding a near-duplicate.
- **Keep the directory structure.** Do not create new top-level folders or parallel trees (`backend/` next to `server/`, `app/` next to `ios/`) without approval. New code goes where `project-layout` says it belongs.
- **Do not change dependencies without approval** — the full procedure is in `dependency-safety.md`.

## Shared contracts

- When a contract is defined in one place and mirrored by hand elsewhere (DTOs, protocol types, error envelopes), **update every side in the same change set**.

## Robustness defaults

- A service must **not crash when a dependency is offline** — return a status, not a 500 or a panic.
- Parsers/writers of config or data files must **round-trip**: read → write → read gives identical output. Cover it with a test.
- Internal-only ports (admin protocols, databases, RCON-style control channels) are **never** published on the host or the internet.
- Sensitive or destructive admin actions are **rate-limited**; do not add unbounded destructive endpoints.
- Public health endpoints return a status only; detailed health is authenticated.
