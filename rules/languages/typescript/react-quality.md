---
description: React quality bar — pure components, rules of hooks, derived state instead of effect-synced state, server state via the data library, stable keys, design-system components
globs: "**/*.{tsx,jsx}"
alwaysApply: false
---

# React quality

**Applies to:** React components, hooks and pages (`*.tsx`, `*.jsx`), including React Native where the rules apply.

**Out of scope:** TypeScript language rules (`typescript-quality.md`), UI copy (`i18n-no-hardcoded-strings.md`), accessibility (`web-accessibility.md`), visual design (`design-system`, `design-sync.md`).

**Origin:** new (2026-10-05) for ownly `frontend/`, pzserver `web/ui` and shroud `web/`.

## Components

- Function components only. Components are **pure**: same props + state → same output; no side effects during render (no fetches, subscriptions, mutations, `Math.random()`/`Date.now()` in render output).
- One component per file for anything non-trivial; file name matches the component.
- Props are typed; no prop drilling deeper than ~2 levels — lift to context or a store when needed, but don't put everything in context.
- Compose from the project's shared UI components (`design-system`); no one-off inline styling or duplicate buttons/inputs in feature code.
- Never define a component inside another component's body (it remounts every render).

## Hooks

- Follow the **Rules of Hooks**: top level only, never in conditions/loops/callbacks. `eslint-plugin-react-hooks` stays enabled with **no** `exhaustive-deps` suppressions — fix the dependency list or restructure.
- Custom hooks start with `use`, do one thing, and return a stable, typed API.

## State

- Keep the **minimal** state. Anything computable from props/state is **derived during render** (with `useMemo` only if expensive) — not copied into state.
- **Do not use `useEffect` to sync state from props or other state**, to transform data for rendering, or to handle user events. Effects are only for synchronizing with **external systems** (subscriptions, timers, imperative APIs, non-React widgets), and must clean up.
- Reset component state with a `key`, not with an effect.
- Use functional updates (`setCount(c => c + 1)`) when the next state depends on the previous one.
- Never mutate state objects/arrays; create new ones.

## Server state

- Data from the API goes through the project's data layer ({{DATA_LIBRARY}}, e.g. TanStack Query / SWR / RTK Query / router loaders) — not ad hoc `useEffect` + `useState` fetches.
- Every remote data view renders **loading, error and empty** states explicitly.
- Query keys are centralized constants; mutations invalidate or update the affected queries.

## Lists, forms, events

- List items have **stable, unique keys** from the data (IDs) — never the array index for dynamic lists.
- Forms: controlled inputs or the project's form library, consistently; validate on the client for UX and on the server for security.
- Event handlers are named `handleX` and passed as `onX` props.

## Performance (only where it matters)

- Don't sprinkle `useMemo`/`useCallback`/`memo` everywhere. Use them for expensive computations, referential stability required by dependencies, or measured re-render problems.
- Virtualize long lists; lazy-load routes (`React.lazy`) and heavy components.

## Security

- No `dangerouslySetInnerHTML` with untrusted content; sanitize if unavoidable (`web-security-baseline.md`).
- No tokens or secrets in client state that persists (`localStorage`) unless the auth design explicitly requires it.

## Before "done"

- Lint (including hooks rules), type-check, tests and the production build pass; the affected screens are smoke-tested in the browser, including loading, error and empty states.
