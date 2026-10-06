---
description: Project design system — tokens, typography, component recipes, screen composition and UI quality gate (fill in per project)
alwaysApply: true
---

# {{PROJECT}} design system

**Applies to:** all design-file edits and all UI code.

**Out of scope:** keeping design files in sync (`design-sync.md`), web accessibility rules (`web-accessibility.md`).

**Origin:** structure from `shroud` (`design-system.mdc`). The full worked example — an iOS 26 Liquid Glass messenger — is in `originals/shroud/.cursor/rules/design-system.mdc`; copy from it when the project is similar.

**How to use:** fill every section from the real design file. Delete the HTML comments. Everything here is binding for both design edits and code, so the app looks like one product rather than a collection of screens.

`{{DESIGN_FILE}}` is the design source of truth (see `design-sync.md`). New screens are designed there **before** implementation.

## Design language

<!-- 3–5 sentences: the feel (e.g. "modern, clean, platform-native: white surfaces, one confident accent, generous whitespace, capsule primary actions, grouped cards, hairline separators"), and what effects are allowed. Example rule: "Effects are intentional and rare — no decorative blurs/gradients on backgrounds, no drop shadows on flat list content, at most one hero effect per screen." -->

## Tokens (never hardcode alternatives)

| Token | Light | Dark | Use |
| --- | --- | --- | --- |
| `accent` | | | Primary actions, links, active states |
| `accent-soft` | | | Selected pills, chips, soft icon circles |
| `bg` | | | Plain screens, cards |
| `bg-grouped` | | | Grouped/settings screens, input fields |
| `text-primary` | | | Headings, body |
| `text-secondary` | | | Captions, metadata, placeholders |
| `separator` | | | 1 px hairlines |
| `success` / `successText` | | | Success chips and labels |
| `warning` / `warningText` | | | Warning callouts |
| `danger` / `dangerText` | | | Destructive fills / small error text (keep 4.5:1) |

In code these become one theme object (`Theme.accent`, CSS variables, Compose `ColorScheme`). Feature code references tokens, **never** literals. Dark mode re-maps tokens; no per-view overrides.

## Typography

| Role | Size / weight | Notes |
| --- | --- | --- |
| Screen title | | Same size on every screen |
| Section / card title | | |
| Body & list rows | | |
| Secondary | | `text-secondary` |
| Caption / labels | | |
| Code / IDs / fingerprints | | Monospace only |

## Component recipes

<!-- One bullet per reusable component with exact numbers: height, radius, padding, fill token, label size/weight, states. E.g.
- **Primary button:** full-width capsule, height 52, `accent` fill, white 17 semibold label.
- **Input field / grouped row:** `bg-grouped`, radius 12, height 48, side padding 14, leading 18 pt icon.
- **Card:** `bg`, radius 14, no shadow on grouped backgrounds.
- **Sheets/overlays, badges/chips, avatars, top bar, tab bar, toasts …** -->

## Screen composition

- Reference frame: {{FRAME_SIZE}} (e.g. 390×844).
- One horizontal padding applied by the content wrapper, never per section.
- Vertical rhythm via stack gaps (e.g. 24–32 between sections, 12–16 between related items) — no spacer views.
- One primary intent per screen; the first two elements answer "where am I / what can I do".
- Anything that scrolls must signal it (content cut at the edge, indicator, or a "See all ›" link).

## Implementation rules

- Build a small component library mirroring the recipes. Feature screens compose these — **no one-off styling in feature views**.
- A new visual pattern is designed in `{{DESIGN_FILE}}` first (screenshot-verified), then added to the component library, then used.

## Quality gate (before "done" on UI work)

1. Screenshot the design frame or the running UI and compare against the recipes: paddings, radii, fonts, colours from tokens only.
2. No clipped/overflowing content; verified at the reference size and with long text.
3. Interactive elements ≥ 44 pt / 48 dp hit targets; text contrast ≥ 4.5:1.
4. Screen names and structure match between design and code.
