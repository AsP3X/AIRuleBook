---
description: package-lock.json must be generated on Linux (the Docker build OS) so npm ci works in the image
globs: "**/package*.json"
alwaysApply: false
---

# npm lockfile must be Linux-complete for Docker `npm ci`

**Applies to:** adding, removing or bumping npm packages, or committing `package.json` / `package-lock.json`, when the production image runs `npm ci` on Linux while developers use Windows or macOS.

**Out of scope:** whether to add or upgrade a package at all (`dependency-safety.md`).

**Origin:** `ownly` (`frontend-npm-lockfile-docker.mdc`).

**Customize:** `{{FRONTEND_DIR}}` (e.g. `frontend`), `{{NODE_IMAGE}}` (e.g. `node:22-alpine`, matching your Dockerfile).

A lockfile produced on Windows/macOS can omit Linux-only optional dependencies (native/WASM bindings used by Rolldown, Tailwind, esbuild, SWC …) and break the image build:

```text
Missing: @emnapi/core@1.10.0 from lock file
Missing: @emnapi/runtime@1.10.0 from lock file
```

## Mandatory when dependencies change

1. **Do not** commit a host-only `npm install` lockfile as the final artifact.
2. **Regenerate the lockfile inside the build image** (from the repo root):
   ```bash
   docker run --rm -v "./{{FRONTEND_DIR}}:/app" -w /app {{NODE_IMAGE}} npm install
   ```
   On Windows PowerShell, if the bind mount fails, use an absolute path with forward slashes (`C:/Users/you/project/{{FRONTEND_DIR}}:/app`).
3. **Verify the Docker build** before claiming done:
   ```bash
   docker build -f {{FRONTEND_DIR}}/Dockerfile {{FRONTEND_DIR}}
   ```
4. **Sanity-check** the lockfile contains resolved entries for the platform-specific optional packages that failed before (e.g. `node_modules/@emnapi/core`, `node_modules/@emnapi/runtime`).

## Checklist (before commit)

- [ ] Lockfile regenerated in `{{NODE_IMAGE}}`.
- [ ] `docker build` passes the `npm ci` step.
- [ ] `npm run build` still passes locally if application code changed.

## Anti-patterns

- Running `npm install` on Windows and committing `package-lock.json` without the Linux refresh.
- Skipping the Docker check because `npm ci` passed on the host OS.
