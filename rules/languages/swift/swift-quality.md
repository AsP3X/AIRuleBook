---
description: Swift/SwiftUI quality bar — no force unwraps, typed models, structured concurrency, MVVM, design-system components, previews
globs: "**/*.swift"
alwaysApply: false
---

# Swift quality

**Applies to:** all Swift code (iOS/iPadOS/macOS apps).

**Out of scope:** visual design (`design-system`, `design-sync.md`), key handling (`security-e2e-crypto.md`).

**Origin:** `shroud` (`swift-quality.mdc`).

## Language & safety

- **No force unwraps (`!`), force casts (`as!`) or `try!`** outside tests. Use `guard let`, `if let`, optional chaining and typed `throw`s.
- Model domain values with **structs and enums**, not dictionaries or stringly-typed data. IDs get dedicated types (`UserID`, `MessageID`).
- Server DTOs are `Codable` structs that mirror the server definitions; when one side changes, update the other in the same change set.
- Use `async/await` and structured concurrency; UI state mutations happen on `@MainActor`. No `DispatchQueue` sprinkling in new code.

## Architecture

- **MVVM:** SwiftUI views are declarative and dumb; logic lives in `@Observable` / `ObservableObject` view models; services (network, storage, crypto) are protocol-backed so they can be mocked.
- Views never talk to the network or database directly.
- Sensitive material (keys, tokens) is only touched inside its dedicated service and never appears in view or view-model code.

## SwiftUI

- Build screens from the shared design-system components (`design-system`); no ad-hoc paddings, colors or font sizes in feature views.
- Every screen supports Dynamic Type, dark mode, and VoiceOver labels on interactive elements.
- Every new view has a `#Preview` that renders without network access.

## Before "done"

- The project builds without warnings; `xcodebuild test` passes; SwiftFormat/SwiftLint (when configured) are clean.
- Test on a **fresh simulator** created for the run (`xcrun simctl create …`), not the user's own simulators; delete it afterwards. Disable parallel testing if Keychain-backed tests fail with `-34018`.
