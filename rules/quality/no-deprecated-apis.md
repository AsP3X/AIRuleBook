---
description: Do not call, extend, shim or suppress deprecated APIs; replace them or implement the behavior
alwaysApply: true
---

# No deprecated APIs

**Applies to:** every code change, on every platform.

**Out of scope:** upgrading packages to get new APIs (`dependency-safety.md`).

**Origin:** `shroud` (`docs/agent-rules/no-deprecated-apis.md`).

Do not call, extend or suppress a deprecated API, type, method, library or language feature. Search the change for deprecation markers and warnings (`@Deprecated`, `#[deprecated]`, `@available(*, deprecated)`, compiler/linter deprecation output) and for suppressions (`@Suppress("DEPRECATION")`, `OVERRIDE_DEPRECATION`, `#[allow(deprecated)]`, `// eslint-disable … deprecation`).

- Replace each use with the current supported API.
- If the platform or library has no supported replacement, implement the behavior in the project.
- Do not add a new deprecated shim so callers can keep the old path.
- Do not silence a deprecation to leave the old call in place.

## Minimum-version cases

An API deprecated only on a newer SDK, while the project's minimum SDK is lower, still counts:

- Use the new API on versions that have it.
- On older versions, implement the behavior without the deprecated method when it can be done in-process.
- Keep a version check calling the deprecated method **only** when the OS exposes that behavior solely through it and there is no in-process equivalent. Leave that compiler note visible; do not suppress it.
