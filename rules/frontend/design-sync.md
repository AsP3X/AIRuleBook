---
description: Every visible UI change also lands in the matching design file in the same piece of work
alwaysApply: true
---

# Keep the designs in sync with the UI

**Applies to:** any change that adds, changes or removes visible UI.

**Out of scope:** the design language itself (`design-system`), web accessibility (`web-accessibility.md`).

**Customize:** the code → design file table; the design tool and how agents may access it.

Every UI change — a new screen or component, a change to an existing one, or a removal — also lands in the matching design file **in the same piece of work**:

| Code | Design file |
| ---- | ----------- |
| {{CLIENT_DIR_1}} (e.g. `ios/`) | {{DESIGN_FILE_1}} (e.g. `design/mobile-app.pen`) |
| {{CLIENT_DIR_2}} (e.g. `web/`) | {{DESIGN_FILE_2}} (e.g. `design/web-app.pen`) |

- A change that touches several clients updates every matching file.
- Removed UI is removed from the design too, not left behind as a stale frame.
- Screens in code map **1:1** to screens in the design; screen names and structure match.
- New screens and new visual patterns are designed **first**, then implemented.
- Reuse the design file's existing components and variables, and match the code: same copy, spacing, colours and states (empty, loading, error).
- If a UI change deliberately skips the design (a pure bug fix with no visible difference), **say so** in the summary instead of silently leaving it out.

## Tool-specific notes (Pencil `.pen` files — delete if not used)

- `.pen` files are encrypted: edit them **only** through the Pencil MCP tools; never read, grep or write them directly.
- Bring the file to the front in the Pen app before editing (`open -a /Applications/Pen.app design/<file>.pen`) and confirm it is the active editor.
- Edits live only in the running Pen app. When done, ask the user to press ⌘S and say plainly that the change is not on disk until they do.
- Before committing a `.pen` file, check its diff holds only this change — a save also writes other sessions' unsaved edits.
- Parallel agents must not edit the same design file at once; assign design work to a single agent and have code agents report **design notes** (screen/state, exact copy, sizes, tokens, frame id) instead.
