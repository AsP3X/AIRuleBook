---
description: TypeScript quality bar — strict mode, no any or unchecked casts, validated external data, typed errors, exhaustive unions, no floating promises
globs: "**/*.{ts,tsx,mts,cts}"
alwaysApply: false
---

# TypeScript quality

**Applies to:** all TypeScript (`*.ts`, `*.tsx`, `*.mts`, `*.cts`) — frontend, Node backends, scripts and tests.

**Out of scope:** React components and hooks (`react-quality.md`), UI strings (`i18n-no-hardcoded-strings.md`), packages (`dependency-safety.md`), API error envelope (`api-error-envelope.md`).

**Origin:** new (2026-10-05) for the TypeScript code in ownly `frontend/`, pzserver `web/ui` and shroud `web/`.

## Compiler and lint

- `tsconfig` keeps `"strict": true`. Do not turn off strict flags, and do not add `skipLibCheck`-style escapes to silence real errors. Recommended extras: `noUncheckedIndexedAccess`, `noImplicitOverride`, `exactOptionalPropertyTypes` (when the project already uses them).
- `tsc --noEmit` (or the project's type-check script) and the linter pass with **no new** errors or warnings.
- No `// @ts-ignore`, `// @ts-nocheck`, or `eslint-disable` to hide a real problem. `// @ts-expect-error` only in tests, with a reason.

## Types

- **No `any`.** Use `unknown` and narrow it, generics, or a precise type. Third-party gaps get a small typed wrapper or a `.d.ts`, not `any`.
- **No unchecked casts** (`as Foo`, `as unknown as Foo`, non-null `!`) to silence the compiler. Narrow with type guards, `in`, `instanceof`, discriminants, or validate. `as const` and `satisfies` are fine.
- Model closed sets as **union types** (`type Status = 'idle' | 'loading' | 'error'`) or `as const` objects; avoid `enum` unless the project already uses them.
- Use **discriminated unions** for state (`{ status: 'error'; error: ApiError } | { status: 'ok'; data: T }`) instead of many optional fields.
- Make `switch` over unions **exhaustive** with a `never` check in `default`.
- Prefer `readonly` arrays/properties for data you don't mutate. Avoid mutation of function arguments.
- Exported functions have explicit parameter and return types.

## External data is `unknown` until validated

- JSON from `fetch`, `localStorage`, `postMessage`, URL params, env vars and files is **untrusted**. Parse it with a schema validator (zod/valibot, or the project's existing one) or a hand-written type guard at the boundary — not `as ResponseType`.
- One typed API client module owns HTTP calls, base URLs, auth headers and error parsing; feature code never calls `fetch` directly.

## Errors and async

- `catch (e)` gives `unknown`: narrow it before reading `.message`. Convert to the project's typed error (e.g. `ApiError`) at the boundary.
- Never swallow errors (`catch {}`) — handle, rethrow with context, or surface to the user.
- **No floating promises:** every promise is `await`ed, returned, or explicitly handled (`void promise.catch(handle)`). Enable `@typescript-eslint/no-floating-promises` where possible.
- Use `Promise.all` / `allSettled` for independent work; don't `await` in a loop when the calls are independent.
- Cancel stale requests (`AbortController`) where results can arrive out of order.

## Code shape

- `const` by default, `let` only when reassigned, never `var`.
- `===` / `!==` only. Use `??` and `?.` instead of `||` when `0`/`''`/`false` are valid values.
- No magic strings for routes, storage keys, query keys or event names — define them once as constants.
- Keep modules focused; no barrel files that create import cycles.
- Dates: use the project's date library or `Intl`; never parse dates with string slicing; store and send ISO-8601 UTC.

## Node / backend specifics

- Read env once into a validated config object at startup (`env-config-sync.md`); no scattered `process.env.X!`.
- Never block the event loop with sync I/O (`readFileSync`, `execSync`) in request paths.

## Before "done"

- Type-check, lint, unit tests and the production build (`npm run build`) pass.
