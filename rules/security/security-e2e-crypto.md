---
description: End-to-end encryption invariants — plaintext and keys never leave the device, no hand-rolled crypto, versioned protocol with fixtures
alwaysApply: true
---

# Security & crypto invariants (end-to-end encrypted apps)

**Applies to:** any project whose promise is end-to-end encryption or client-side key custody (messengers, vaults, password managers, encrypted storage). Many of the server rules are good defaults for any app with accounts.

**Out of scope:** baseline web security for every backend — authz, input validation, sessions (`web-security-baseline.md`), secrets in code and output (`secrets-handling.md`).

**Origin:** `shroud` (`security-crypto.mdc`), generalized.

These invariants are **non-negotiable**. A change that violates one is wrong even if it "works".

## Plaintext boundary

- **Plaintext exists only on devices.** The server stores and relays ciphertext; it must never gain a decryption path, a "debug mode" or plaintext logging.
- **Private keys and recovery phrases never leave the device.** They live in the platform keystore (iOS Keychain/Secure Enclave, Android Keystore, WebCrypto non-extractable keys). They are never sent over the network, written to the server DB, logged, or put in analytics/crash reports.
- Processing of decrypted content (transcription, previews, search) happens **on-device**. Do not add server-side processing of decrypted data.

## Crypto implementation

- **Never hand-roll cryptographic primitives.** Use vetted libraries (libsignal, `ring`, RustCrypto, CryptoKit, Tink …). No custom cipher modes, padding or key derivation.
- Key exchange, ratcheting and envelope formats are **versioned protocol surfaces** — changes require archived fixtures and backtests (`regression-testing.md`).
- Randomness comes from the platform CSPRNG only.
- Constant-time comparison for MACs, tokens and fingerprints; no early-exit equality on secret material.

## Server rules (good defaults for any app)

- Auth tokens are opaque, hashed at rest, and expiring; passwords use a memory-hard KDF (argon2id).
- No endpoint returns another user's key material without an authenticated, rate-limited request; log such fetches for abuse detection (metadata only).
- Store the **minimum metadata** needed. Adding a stored field requires stating why it cannot be encrypted or omitted.

## Client rules

- Key material is accessed through a **single crypto service**; views and view models never see raw keys.
- Screens showing recovery phrases or key fingerprints block screenshots where feasible and never cache their contents.
- Copying sensitive data to the clipboard uses expiring, local-only clipboard options.
- No tokens or keys in UI state that is persisted or restored (saved instance state, `rememberSaveable`, logs).

## Review checklist for any crypto-adjacent change

1. Does plaintext or key material cross the device boundary anywhere (network, logs, analytics, crash reports)? Must be **no**.
2. Is a protocol/envelope version bumped with fixtures archived?
3. Are error messages free of secret material (`api-error-envelope.md`)?
4. Are key flows documented with `Human:`/`Agent:` comments (`inline-documentation.md`)?
