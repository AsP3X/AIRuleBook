---
description: Rust quality bar — no panics in non-test paths, typed errors, no blocking in async, justified unsafe, no lint suppressions
globs: "**/*.rs"
alwaysApply: false
---

# Rust quality

**Applies to:** all Rust code (`*.rs`) in the workspace.

**Out of scope:** dead-code allows (`rust-no-dead-code-allow.md`), error body shape (`api-error-envelope.md`), crates (`dependency-safety.md`).

**Origin:** `shroud` (`rust-quality.mdc`); the dead-code section merges `rust-no-dead-code-allow.md`.

## Error handling (no panics in production paths)

- **No `unwrap()`, `expect()`, `panic!`, `unreachable!`, panicking indexing, or `unwrap_or_default()` that hides errors** in non-test code. Return `Result` and propagate with `?`.
- API errors flow through the project's single error type (`api-error-envelope.md`). Use `thiserror` for typed error enums and `From` conversions — no stringly-typed errors.
- `expect()` is acceptable only for genuine start-up invariants that should crash loudly (e.g. missing required config at boot); prefer validated config structs.
- In tests, `unwrap`/`expect` are fine.

## Dead code

- Never `#[allow(dead_code)]` — see `rust-no-dead-code-allow.md`.

## Concurrency & async

- **Never block the async runtime:** no blocking I/O, `std::thread::sleep` or CPU-heavy loops on executor threads. Use async APIs or `spawn_blocking`.
- Document non-obvious task and channel lifetimes in latency-sensitive paths (WebSockets, relays, streaming) (`inline-documentation.md`).

## Unsafe & lints

- **`unsafe` needs a written justification** comment naming the invariant it upholds; prefer safe alternatives.
- Crypto uses vetted crates, never hand-rolled primitives.
- **Do not silence lints** with broad `#[allow(...)]`. New `cargo clippy -- -D warnings` failures are fixed, not suppressed.
- Run `cargo fmt`; do not hand-format against rustfmt.

## Types & API design

- Prefer strong types over primitives (newtypes such as `UserId`, `DeviceId`; enums for closed sets).
- Validate external input at handler boundaries into typed values before use.
- Public items in library crates need rustdoc.

## Logging

- Use `tracing` (`error!`/`warn!`/`info!`), not `println!`, in request paths. Log the real error with `error = %e`; map to a safe client message separately.

## Before "done"

- `cargo fmt --check`, `cargo clippy --all-targets -- -D warnings` and `cargo test --workspace` pass.
