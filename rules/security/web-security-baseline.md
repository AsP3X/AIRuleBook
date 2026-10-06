---
description: Security baseline for every HTTP backend — authorization on every route including object ownership, validated input, parameterized queries, safe sessions, CSRF/XSS/SSRF defenses, rate limits
alwaysApply: true
---

# Web security baseline

**Applies to:** server-side code of any application that exposes HTTP endpoints (REST, GraphQL, WebSocket, webhooks, admin panels), and the web clients that talk to it.

**Out of scope:** secrets in code/output (`secrets-handling.md`), error body shape and log redaction (`api-error-envelope.md`), audit trails (`audit-log-coverage.md`), E2E encryption (`security-e2e-crypto.md`), third-party packages (`dependency-safety.md`).

## Authentication

- Passwords are hashed with **argon2id** (or bcrypt/scrypt with current parameters) — never plain, never fast hashes (MD5/SHA-*).
- Session tokens are random (≥ 128 bits), opaque, **hashed at rest**, expiring, and revoked on logout and password change.
- Cookies: `HttpOnly`, `Secure`, `SameSite=Lax` (or `Strict`), scoped path/domain. Never put tokens in `localStorage` when a cookie works.
- JWTs: verify the signature **and** algorithm (reject `none`), `exp`, `iss`/`aud` where used; short-lived; no sensitive data in the payload.
- Login, registration, password reset and token endpoints are **rate-limited** and return the same response for "unknown user" and "wrong password".

## Authorization (the most common bug)

- **Every** route checks authorization on the server — never rely on the UI hiding a button.
- Check **object ownership** on every read and write by ID (`GET /files/:id` must verify the file belongs to the caller or the caller's group). Missing ownership checks = IDOR.
- Deny by default: a new route is private unless explicitly made public. Public routes are listed and justified.
- Role/permission checks happen in one shared layer (middleware/extractor/guard), not ad hoc per handler.
- Admin and destructive actions require an admin role **and** are rate-limited and audited.

## Input handling

- Validate every external input at the boundary into typed values: type, length, range, format, allowed values. Reject unknown fields where the framework allows.
- Set request **body size limits** and pagination limits (`backend-performance.md`).
- **SQL:** parameterized queries / query builders only. Never build SQL with string formatting or concatenation of input — including `ORDER BY` and table names (allowlist those).
- **Shell / processes:** never pass input to a shell; use argument arrays; allowlist commands.
- **File paths:** never join user input into a path without normalizing and checking it stays inside the intended directory (path traversal). Generate stored file names server-side.
- **Uploads:** check size and type by content, store outside the web root, serve with `Content-Disposition` and a safe `Content-Type`.
- **Deserialization:** no unsafe deserializers (pickle, YAML `load`, Java native) on untrusted input.

## Output and browser

- Escape output by context; rely on the framework's auto-escaping. No `dangerouslySetInnerHTML` / `v-html` / `innerHTML` with untrusted data — sanitize with a vetted library if HTML is required.
- **CSRF:** cookie-authenticated state-changing requests need SameSite cookies plus a CSRF token or origin check.
- **CORS:** explicit allowlist of origins; never `*` with credentials; never reflect the `Origin` header.
- Security headers: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `frame-ancestors`/`X-Frame-Options`, HSTS in production.

## Outbound requests (SSRF)

- Server-side fetches of user-supplied URLs use an allowlist of hosts/schemes, block private/loopback/link-local/metadata IPs (after DNS resolution), and disable redirects or re-check each hop.

## Exposure

- Internal ports (databases, admin consoles, RCON, Docker socket, metrics) are bound to internal networks only — never published to the host's public interface.
- Public health endpoints return status only; detailed health/metrics require auth.
- Debug endpoints, stack traces, directory listings and verbose errors are off in production.
- Webhooks verify signatures and timestamps (replay protection).

## Privacy

- Collect and store the minimum personal data; never log passwords, tokens, full card numbers or document IDs; redact emails/IPs in logs where not needed.

## Review checklist for a new or changed endpoint

1. Who may call it? Is that enforced server-side, including object ownership?
2. Is every input validated and size-limited?
3. Are queries parameterized and paths/commands safe?
4. Is it rate-limited if it is auth-related, expensive or destructive?
5. Does the response leak data the caller may not see (other users' fields, internal IDs, stack traces)?
6. Is it audited if it mutates (`audit-log-coverage.md`)?
