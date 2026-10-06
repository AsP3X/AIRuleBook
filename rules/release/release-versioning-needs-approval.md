---
description: Version numbers are release numbers — bump only after the user answers yes to an explicit release question; keep every version string in lockstep
alwaysApply: true
---

# Version bumps need an explicit release decision

**Applies to:** any project with a published artifact (store/workshop item, package registry, app store build, plugin) whose version is written in source.

**Out of scope:** publishing the release itself (`external-actions.md`), changelog content (`docs-upkeep.md`).

**Origin:** `pzserver` (Knox Relay versioning + "Always ask before a Workshop release"), generalized.

**Customize:** list the version strings and the packaging/consistency check.

## Version numbers are release numbers only

- **Do not bump the version** unless the user explicitly answered **yes** to the release question below. Local-only fixes keep the last released version. Do not invent a new number because a file changed.
- Not bumping is **not** permission to skip deployment — deploy anyway (`deploy-to-running-targets.md`).

## Version strings stay in lockstep

All of these must always match each other (and the live version after deploy):

- {{VERSION_LOCATION_1}} (e.g. `modversion=` in `mod.info`)
- {{VERSION_LOCATION_2}} (e.g. `VERSION` constant in the main source file)

A consistency check (`{{CHECK_CMD}}`, e.g. the packager or a manifest test) refuses mismatches. **That check is not a deploy**, and running the packager is not a substitute for asking.

The project's own artifact always shows a version. Never fill a missing version for third-party items from a date or guess.

## Always ask before a release

After any session that changed the published code, and **after** every target runs the new code, ask using the agent's **question dialog** (AskUserQuestion / the TUI question UI) — not a sentence buried at the end of a reply:

> **"Prepare the next {{ARTIFACT}} release?"**

- **Yes** → bump every version string together, write the changelog/changenote, package, deploy all targets on the new version, and after the user publishes confirm the store, the server and the client all report the same version.
- **No** → leave every version string unchanged. Do not package, do not write a changelog, do not touch publish metadata (e.g. upload IDs).

Never bump first and ask later. Never treat "the feature is done" as permission to cut a release.
