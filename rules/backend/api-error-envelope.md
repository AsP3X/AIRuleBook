---
description: One canonical JSON error envelope per API surface; safe client messages; real errors only in logs; clients updated in the same change
alwaysApply: true
---

# API responses, errors and logging

**Applies to:** HTTP API handlers, auth middleware, and every API client in the repo.

**Out of scope:** authentication and authorization (`web-security-baseline.md`), secrets in general (`secrets-handling.md`), audit trails (`audit-log-coverage.md`).

**Origin:** `ownly`, `shroud` (nested envelope), `nebular-os` (flat envelope) — merged.

**Customize:** choose **one** envelope variant, fill `{{ERROR_TYPE}}`, `{{ERROR_TYPE_PATH}}` and the client list, and delete the other variant.

## Canonical error JSON

### Variant A — structured (recommended for app APIs)

```json
{ "error": { "code": "string", "message": "string" } }
```

Produced by `{{ERROR_TYPE}}` (e.g. Rust `AppError` implementing `IntoResponse`) in `{{ERROR_TYPE_PATH}}`. Handlers return `Result<…, {{ERROR_TYPE}}>`; the status code comes from the same type.

### Variant B — flat (small services, storage/S3-like APIs)

```json
{ "error": "not found" }
```

Short, stable messages for known cases (`"not found"`, `"unauthorized"`, `"range not satisfiable"`). Success payloads stay minimal (e.g. `{ "etag": "…" }`).

### Either way

- **Never** introduce a second error shape on the same API surface (plain text, `{ "message": … }`, a different nesting) unless the user explicitly approves a **breaking** contract change — and then update the tests and **every client** in the same work.
- Use the right status: 400 validation, 401 unauthenticated, 403 forbidden, 404 not found, 409 conflict, 413 too large, 416 range, 429 rate limited, 500 internal.

## What clients see vs. what logs contain

- **Responses:** `message`/`error` strings are **safe for end users** — no stack traces, SQL fragments, file paths, internal hostnames, tokens, key material or secrets. For internal failures a generic message is fine; the detail goes to the log.
- **Logs:** use structured logging (e.g. `tracing::error!(error = %e, …)`) with enough detail to debug. Request tracing goes through middleware (e.g. `tower_http::TraceLayer`), not `println!`.
- **Never log** credentials, session tokens, JWTs, signing secrets, presigned query secrets, message plaintext or key material, or full third-party error payloads unless scrubbed.
- Do not log **PII** at error level in hot paths without redaction.

## Client alignment

- Clients ({{CLIENTS}}, e.g. `frontend/src/api/client.ts` `getErrorMessage`, a Swift `APIError` decoder, a Kotlin `ApiError`) parse exactly this envelope. **When the server schema changes, update every client's error parsing in the same change set** and extend old-client tests (`regression-testing.md`).

## Non-JSON routes

- Health/metrics endpoints return stable JSON for probes; keep them stable. Streaming bodies are not JSON but must still not leak internals in headers.

## Anti-patterns

- Mixing JSON and plain-text errors on the same base path.
- Returning 500 with internal causes in the client-visible message.
- Logging PII or secrets at error level.
