---
description: Never hardcode user-facing strings in UI components; every key goes through t() and into every locale file
globs: "**/*.{tsx,jsx,vue,svelte}"
alwaysApply: false
---

# Internationalization: no hardcoded UI strings

**Applies to:** every user-facing string in UI code — public pages, admin, auth and shared components.

**Out of scope:** accessibility labels beyond translation (`web-accessibility.md`).

**Origin:** `pzserver` (`CLAUDE.md` → Internationalization).

**Customize:** `{{T_HOOK}}` (e.g. `useTranslation()` from `web/ui/src/i18n/use-translation.ts`), `{{LOCALE_FILES}}` (e.g. `en.json`, `de.json`), placeholder syntax.

- **Never hardcode user-facing strings** in components — always use `t()` from `{{T_HOOK}}`. This includes button labels, headings, placeholders, empty states, toasts, `aria-label`s and error messages shown to users.
- When adding a page or component, add **all** its keys to **every** locale file ({{LOCALE_FILES}}) in the same change — not only the default language.
- Use namespaced, dotted keys that mirror the screen: `admin.players.count`, `auth.login.submit`.
- Dynamic values use the project's placeholder syntax, never string concatenation:
  `t('admin.players.count', { count: players.length })` with `"{{count}} players"` / `":count players"` per your library.
- If the project supports runtime overrides (e.g. translations edited in an admin page and stored in the DB), those override the JSON defaults — do not bypass that lookup.
