---
description: Never silence unused code with #[allow(dead_code)]; delete it or wire it into a real path
globs: "**/*.rs"
alwaysApply: true
---

# Rust: never silence unused code

**Applies to:** all Rust code.

**Out of scope:** other lint and quality rules (`rust-quality.md`).

**Origin:** `nebular-os`, `ownly` (`rust/no-allow-dead-code.mdc`), `pzserver` (`AGENTS.md`) — merged; the enforcement section comes from `pzserver`.

`#[allow(dead_code)]` — on items, fields, modules, or via `cfg_attr(..., allow(dead_code))` — is **forbidden**.

If rustc reports dead code:

- **Use the value** in a real path (logic, metrics, logs, UI), or
- **Remove the code** if it is truly unused, or
- **Prefix with `_`** only when an external API/schema requires the item and it cannot be removed.

Do not replace the allow with an `#[expect(dead_code)]`, a dummy read, or a fake call. Reserved constants belong on an allowlist that production code actually consults, not behind a lint exception.

## Enforcement (recommended)

- Workspace lints: in `Cargo.toml`
  ```toml
  [workspace.lints.rust]
  dead_code = "deny"
  ```
- A CI/check script that greps for the attribute so `deny` cannot be bypassed:
  ```bash
  ! grep -rnE 'allow\((.*,\s*)?dead_code' --include='*.rs' src crates
  ```
