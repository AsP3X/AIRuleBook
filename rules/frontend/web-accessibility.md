---
description: Web UI meets WCAG 2.2 AA — semantic HTML, keyboard operable, visible focus, labels and names, contrast, motion and zoom; verified before done
globs: "**/*.{tsx,jsx,html,vue,svelte,css,scss}"
alwaysApply: false
---

# Web accessibility (WCAG 2.2 AA)

**Applies to:** every web UI change — pages, components, dialogs, forms, emails rendered as HTML.

**Out of scope:** native app accessibility (`swift-quality.md`, `android-quality.md`), visual tokens and recipes (`design-system`), translated strings (`i18n-no-hardcoded-strings.md`).

**Origin:** new (2026-10-05); the web counterpart of the hit-target and contrast gate in shroud's `design-system.mdc`.

## Semantics first

- Use the right native element: `<button>` for actions, `<a href>` for navigation, `<input>`/`<select>`/`<textarea>` for input, `<table>` for tabular data, headings `<h1>`–`<h6>` in order, landmarks (`<header>`, `<nav>`, `<main>`, `<footer>`). Never a clickable `<div>`/`<span>`.
- ARIA only when no native element fits — and then the full pattern (role, state, keyboard). No ARIA is better than wrong ARIA.
- One `<h1>` per page; the document `<title>` and `lang` attribute are set and updated on route change.

## Names and labels

- Every form control has a visible `<label>` (or `aria-labelledby`); placeholders are not labels.
- Icon-only buttons and links have an accessible name (`aria-label` or visually hidden text).
- Images: meaningful `alt`; decorative images `alt=""`.
- Errors are tied to their field (`aria-describedby`, `aria-invalid`) and announced; don't rely on color alone.

## Keyboard

- Everything works with keyboard only: Tab order follows visual order, no keyboard traps, `Esc` closes dialogs/menus.
- **Visible focus** indicator on every focusable element; never `outline: none` without a replacement.
- Dialogs: move focus in on open, trap focus while open, restore focus on close; use `<dialog>` or the design system's accessible modal.
- Custom widgets (menus, tabs, comboboxes) follow the WAI-ARIA Authoring Practices keyboard model.

## Visual

- Text contrast ≥ 4.5:1 (≥ 3:1 for large text and UI component boundaries/icons).
- Pointer targets ≥ 24×24 CSS px (prefer 44×44 for primary actions).
- Works at 200% zoom and 320 px width without loss of content or horizontal scrolling of text.
- Respect `prefers-reduced-motion`; no flashing content; auto-playing motion can be paused.
- Information is never conveyed by color alone (add icons, text or patterns).

## Dynamic content

- Loading and async results are announced (`aria-live="polite"` / status regions) where the change isn't otherwise obvious.
- Toasts that require action don't disappear on a timer.

## Verify before "done"

1. Keyboard walk-through of the changed flow (Tab, Shift+Tab, Enter, Space, Esc, arrows).
2. Automated check with axe (browser extension, `@axe-core/playwright`, or Lighthouse) — no new violations.
3. Contrast of any new color pair checked.
4. Screen-reader spot check (VoiceOver / NVDA) for new custom widgets.
