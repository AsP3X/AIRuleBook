---
description: Android quality bar — layered architecture with UI isolated from data and crypto, Compose state rules, threading contract, permissions, no secrets in saved state, project platform constraints, safe device testing
globs: "**/android/**"
alwaysApply: false
---

# Android quality

**Applies to:** Android app code, resources, manifests and Gradle modules (Jetpack Compose or Views).

**Out of scope:** Kotlin language rules (`kotlin-quality.md`), visual design (`design-system`, `design-sync.md`), E2E crypto (`security-e2e-crypto.md`), deprecated APIs (`no-deprecated-apis.md` — includes API-level-gated deprecations).

**Customize:** the platform constraints table; `{{BUILD_GATE}}`.

## Architecture

- Layers: **UI** (composables, view models) → **domain/controllers** → **data** (network, storage, crypto, system services). UI code never touches the data layer directly.
- Under the UI package there is **no** HTTP client, database/DAO, `SharedPreferences`/DataStore, file I/O, `MediaStore`, crypto or keystore access. UI calls controllers/ports through interfaces that forward 1:1 to the core.
- Dependencies are injected (Hilt/Koin/manual container as the project uses); no service locators or singletons reached from composables.
- If a needed contract (method, behavior, resource) is missing in a layer you don't own, **don't edit that layer** — report the gap.

## Threading contract

- Call UI-facing controllers from Main; members documented as "off main" run on an injected IO dispatcher.
- No disk, network or crypto on Main (StrictMode in debug builds is recommended).

## Compose

- Composables are side-effect free; side effects only in `LaunchedEffect` / `DisposableEffect` / `rememberCoroutineScope` with correct keys and cleanup.
- **State hoisting:** screens take state + event lambdas; view models expose a single immutable UI state (`StateFlow<UiState>`), collected with `collectAsStateWithLifecycle()`.
- Use `remember` for in-composition state and `rememberSaveable` only for small UI state — **never tokens, keys, names or message content** in saved state.
- Lists use `LazyColumn` with stable `key`s; mark UI state classes stable/immutable where needed.
- Every screen handles loading, error and empty states and survives configuration change and process death.

## Platform

- Request runtime permissions **in context**, with rationale, and handle "denied" and "don't ask again".
- Respect min/target SDK: new APIs behind `Build.VERSION.SDK_INT` checks.
- Strings in `strings.xml` (no hardcoded UI text), dimensions in dp/sp, colors from the theme — never literals in composables.
- Accessibility: `contentDescription` on icons with meaning, touch targets ≥ 48 dp, text scales with font size.
- No secrets, tokens or personal data in logs (`Log.*`), notifications or analytics.

## Project platform constraints

| Constraint | Enforced by |
|---|---|
| {{CONSTRAINT}} (e.g. no Material components) | {{CHECK}} (e.g. `:app:verifyNoMaterial`) |
| {{CONSTRAINT}} (e.g. no Google Play Services / Firebase) | {{CHECK}} (e.g. `:app:verifyNoGoogleServices`) |

## Build and test

- Gate: `{{BUILD_GATE}}` (e.g. `:app:testDebugUnitTest :app:lintDebug :app:assembleDebug`) green; lint adds **no new warnings** in your files.
- Unit tests for view models and rules (Robolectric / Compose test harness as the project uses); instrumentation tests for flows that need a device.
- Devices: use only emulators created for or assigned to the task; target them explicitly (`ANDROID_SERIAL=emulator-<port>`, `adb -s`). **Never install on the owner's own devices/emulators.** Shut down what you started.
- `am instrument` exits 0 even on failure — check for `OK (` and `INSTRUMENTATION_CODE: -1`.
