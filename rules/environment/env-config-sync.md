---
description: Every config/env change updates .env.example, docs and all deployment files together; config is read once, validated and fails fast at startup
alwaysApply: true
---

# Environment and configuration sync

**Applies to:** adding, renaming, removing or changing the meaning/default of any environment variable, config key, feature flag or command-line option the application reads.

**Out of scope:** secret values (`secrets-handling.md`), which store is authoritative at runtime (`single-source-of-truth.md`), creating new compose files (`docker-compose-safety.md`).

**Origin:** new (2026-10-05); pattern seen in ownly (`.env.example`, `init-env.sh`, compose defaults), nebular-os (`NOS_*`, ≥ 32-char secrets) and pzserver (`.env.example`, `.env.production.example`).

**Customize:** `{{CONFIG_MODULE}}` (e.g. `src/config.rs`, `backend/src/config.ts`), `{{ENV_FILES}}`, `{{PREFIX}}` (e.g. `NOS_`, `OWNLY_`).

## Update everything in the same change set

When a config variable changes, update **all** of these that exist:

1. `{{CONFIG_MODULE}}` — the single place config is read and validated.
2. `.env.example` (and other `{{ENV_FILES}}`, e.g. `.env.production.example`) — with a **placeholder or safe default** and a one-line comment: purpose, allowed values, unit, default.
3. Init/bootstrap scripts that generate `.env` (e.g. `init-env.sh`).
4. `docker-compose*.yml`, Kubernetes manifests, CI workflow env, deploy scripts.
5. README / configuration docs table.
6. Tests that construct config.

Renaming or removing a variable is a **breaking change** for existing deployments: keep reading the old name with a deprecation warning for a release, or document the migration step explicitly.

## Naming

- `UPPER_SNAKE_CASE` with the project prefix (`{{PREFIX}}DATABASE_URL`). Units in the name when not obvious (`_SECS`, `_MS`, `_BYTES`, `_MB`).
- Booleans accept a documented set (`true/false`); don't invent `yes`/`1`/`on` variants.

## Read once, validate, fail fast

- Read env/config **once at startup** into a typed config object; pass that object around. No scattered `env::var` / `process.env.X` / `os.environ[...]` in business code.
- Validate at startup: required values present, types parse, ranges and minimum lengths (e.g. secrets ≥ 32 chars), URLs well-formed, mutually exclusive options. On failure, **exit with a clear message naming the variable** — never start half-configured.
- Defaults are **safe for development only** when they are insecure (e.g. a dev secret) and refuse to start in production mode (`{{PREFIX}}ENVIRONMENT=production`) with an insecure default.
- Log the effective non-secret configuration at startup (secrets redacted or shown as `set`/`unset`).

## Environments

- Environment differences come from env vars, profiles or config files — not code branches on hostnames.
- Local `.env` is git-ignored; never commit a filled-in `.env`.
