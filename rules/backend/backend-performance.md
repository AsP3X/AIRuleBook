---
description: Backend performance basics — no N+1 queries, paginate and bound every list, index what you filter on, timeouts on every outbound call, stream large payloads, no unbounded memory
alwaysApply: false
---

# Backend performance basics

**Applies to:** backend code that queries databases, serves lists, calls other services, or handles files and large payloads.

**Out of scope:** blocking the async runtime (`rust-quality.md`, `typescript-quality.md`), React rendering (`react-quality.md`), migrations mechanics (`sql-migrations-immutable.md`), rate limiting as a security control (`web-security-baseline.md`).

These are defaults that prevent the common production slowdowns. Don't micro-optimize beyond them without a measurement.

## Database access

- **No N+1 queries:** never run a query per item in a loop. Use joins, `WHERE id = ANY($1)` / `IN (...)` batching, or the ORM's eager loading.
- Select only the columns you need; no `SELECT *` in hot paths.
- Every column used in a frequent `WHERE`, `JOIN` or `ORDER BY` has a suitable index — add it in a **new** migration. For new queries on large tables, check the plan (`EXPLAIN ANALYZE`).
- Keep transactions short; never hold a transaction open across network calls or user think time.
- Use the connection pool; never open a connection per request. Pool size is configured, not default-guessed.
- Bulk writes use batch inserts / `COPY`, not row-by-row loops.

## Lists and payloads

- **Every list endpoint is paginated** with a server-enforced maximum page size (e.g. default 50, max 200). Prefer cursor/keyset pagination for large or frequently-changing tables.
- No endpoint returns an unbounded collection or loads an entire table into memory.
- Large files and exports are **streamed** (chunked bodies, streaming readers/writers), not buffered fully in memory.
- Request bodies have size limits.

## Outbound calls

- Every HTTP/RPC/DB call has a **timeout**. Retries only for idempotent operations, with exponential backoff and jitter, and a cap.
- Run independent calls concurrently; don't serialize them.
- A slow or offline dependency degrades the feature, not the whole service (`codebase-conventions.md`: return status, not 500/panic).

## Caching

- Cache only with a clear invalidation strategy and TTL; never cache per-user or permissioned data in a shared cache without the user/permission in the key.

## Background work

- Long-running or bulk work (imports, transcoding, thumbnailing, emails) goes to a background job/queue, not the request path. Jobs are idempotent and resumable.

## Measure

- When a change could affect performance, state the expected cost (queries per request, rows scanned, memory) in the summary; for hot paths, measure before and after.
