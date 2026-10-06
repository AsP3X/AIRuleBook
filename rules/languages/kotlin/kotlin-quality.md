---
description: Kotlin quality bar — null safety without !!, sealed types for state and results, structured coroutines with correct dispatchers, immutable data, no lint suppressions
globs: "**/*.{kt,kts}"
alwaysApply: false
---

# Kotlin quality

**Applies to:** all Kotlin code (`*.kt`, `*.kts`) — Android apps, JVM backends, Gradle scripts and tests.

**Out of scope:** Android platform and Compose rules (`android-quality.md`), deprecated APIs (`no-deprecated-apis.md`), packages (`dependency-safety.md`).

**Origin:** new (2026-10-05); language-level rules distilled from the contract rules in `shroud/.claude/android-ui/BRIEF.md`.

## Null safety

- **No `!!`** outside tests. Use `?.`, `?:`, `let`, `requireNotNull(x) { "reason" }` for real invariants, or early returns.
- No `lateinit` for values that can be provided in the constructor; never for nullable or primitive types.
- Platform types from Java APIs are treated as nullable until proven otherwise.

## Types and data

- Model domain values with `data class` / `@JvmInline value class` (IDs: `UserId`, `MessageId`) instead of raw `String`/`Long`.
- Closed sets of states and results are `sealed interface`/`sealed class` (or `enum` for simple constants); `when` over them is **exhaustive** with no `else` branch.
- Prefer immutability: `val`, read-only `List`/`Map`, `copy()` for changes. Expose `StateFlow`/`List`, keep `MutableStateFlow`/`MutableList` private.
- No stringly-typed maps for structured data; use typed classes and a serializer (kotlinx.serialization / Moshi as the project uses).

## Errors

- Expected failures are values: a sealed `Result`/outcome type or `kotlin.Result` with typed errors — not exceptions for control flow.
- Never `catch (e: Exception) {}` or `catch (e: Throwable)` silently. Catch the narrowest type, and **always rethrow `CancellationException`** (`catch (e: CancellationException) { throw e }` before broader catches, or use `runCatching` carefully).
- No `error()`/`TODO()` left in production paths.

## Coroutines

- **Structured concurrency only:** launch in an owned scope (`viewModelScope`, `lifecycleScope`, an injected `CoroutineScope`). **Never `GlobalScope`**, never `runBlocking` in production code (tests: `runTest`).
- Blocking I/O and CPU-heavy work run on an **injected** dispatcher (`Dispatchers.IO` / `Default`), never on Main; inject dispatchers so tests can replace them.
- Functions that do I/O are `suspend` and **main-safe** (they switch context themselves).
- Collect flows lifecycle-aware; use `stateIn`/`shareIn` with a proper `SharingStarted` policy.
- No `Thread.sleep`; use `delay`. In tests, use virtual time (`runTest`, `advanceUntilIdle`).

## Style and lint

- Follow the project's ktlint/detekt configuration; no new `@Suppress` (especially `DEPRECATION`, `UNCHECKED_CAST`) to silence a real finding.
- Prefer expression bodies and scope functions where they make code clearer, not nested `let`/`apply` chains.
- Public APIs have KDoc; ported behavior cites the reference implementation (`file:line`).

## Before "done"

- Build, unit tests and lint/detekt tasks pass with no new warnings in changed files.
