---
description: Regression testing and backtesting requirements when adding or changing features — preserve contracts, test the blast radius, guard every bug fix
alwaysApply: true
---

# Regression testing & backtesting

**Applies to:** every feature, refactor and bug fix.

**Out of scope:** honest test practice — no skipping, weakening or gaming (`test-integrity.md`), debugging failures (`root-cause-debugging.md`).

**Customize:** fill in the test inventory, verification matrix and manual smoke paths for your project. Delete the backtesting section if you have no versioned protocol or persisted data format.

New features and refactors must **not break existing behavior**. Regression protection is part of the feature, not optional cleanup.

## Mindset

- **Preserve contracts:** HTTP status codes, JSON envelopes (`api-error-envelope.md`), auth flows, wire/protocol formats, migration behavior, push payloads and user-visible flows must keep working — unless the task explicitly documents a breaking change and updates **all** consumers in the same work.
- **Test the blast radius, not just the diff:** ask which existing paths your change touches (auth, storage, DB queries, routing, shared components).
- **Add a guardrail when you fix a bug:** add or extend a test so the same regression cannot return silently.

## Backtesting (protocol & data compatibility)

"Backtesting" = replaying historical data and old client behavior against new code:

- **Payload fixtures:** keep serialized payloads (message envelopes, API requests/responses, file formats) from every released version under `{{FIXTURE_DIR}}`. New code must still accept every archived fixture, or the task documents a versioned break plus a client migration.
- **Migration backtests:** a test runs all migrations from empty **and** from a seeded previous-release schema dump.
- **Old-client simulation:** when changing an endpoint, send the previous request shape and assert it still succeeds or fails with the documented, versioned error.
- When adding a new protocol/format version, **archive a fixture for it in the same change**.

## Test inventory

| Area | Automated checks | Notes |
| --- | --- | --- |
| {{AREA}} (e.g. backend) | {{COMMANDS}} (e.g. `cargo test`, `cargo clippy -- -D warnings`) | Integration tests for HTTP-visible behavior |
| {{AREA}} (e.g. frontend) | {{COMMANDS}} (e.g. `npm run build`, `npm run lint`) | Manual smoke of key flows |
| Migrations | Startup / test suite | New forward migrations only |

## Verification matrix (by change type)

| You changed… | Required checks |
| --- | --- |
| API handler, middleware, auth | Backend tests; extend an integration test when behavior is HTTP-visible; old-client check |
| Wire protocol / envelope / file format | Fixture backtests for **all** archived versions; archive a new fixture; tests on every consumer |
| SQL schema or queries | New migration file only; migration backtest; backend tests; smoke affected flows |
| Error responses or status codes | API tests; confirm every client still parses errors |
| UI pages, components, view models | Build + lint + unit/snapshot tests; manual smoke of affected flows |
| Cross-cutting refactor | Full suites of every touched component + linters |

## Manual smoke paths

1. {{FLOW_1}} (e.g. setup / onboarding)
2. {{FLOW_2}} (e.g. login / logout; protected routes reject without a token)
3. {{FLOW_3}} (e.g. the core create / read / update / delete flow)
4. {{FLOW_4}} (e.g. data persists after a restart)

Report which commands and smoke paths you ran when claiming completion.
