---
description: A git submodule / vendored upstream is read-only inside this repo — changes go upstream as a patch, here only the pointer moves
alwaysApply: true
---

# Vendored submodule is read-only

**Applies to:** a dependency checked out as a git submodule (or vendored copy) whose source of truth is another repository.

**Out of scope:** third-party packages from registries (`dependency-safety.md`).

**Customize:** `{{SUBMODULE_DIR}}` (e.g. `vendor/storage-service`), `{{UPSTREAM_URL}}`.

`{{SUBMODULE_DIR}}/` is a git submodule pointing at {{UPSTREAM_URL}}. This repo records only the **pinned commit**; all source changes to it belong upstream.

## Mandatory for agents

- **Never** create, edit or delete files under `{{SUBMODULE_DIR}}/` in this workspace — including its agent rules, tests, Dockerfile and sources.
- **Never** `git add` paths under `{{SUBMODULE_DIR}}/*`; the only allowed change is bumping the submodule pointer (`git add {{SUBMODULE_DIR}}`, gitlink only).
- **Upstream bugs or features:** produce a **unified diff** or `git format-patch` for the user, or describe the change for them to apply upstream. Do not fix it inside this checkout.
- **Integration changes** (env alignment, limits, compose wiring, the client code that calls it) are made in **this** repo only.

## Bumping the dependency

After the user merges work upstream:

```bash
cd {{SUBMODULE_DIR}} && git fetch && git checkout <tag-or-sha>
cd .. && git add {{SUBMODULE_DIR}} && git commit -m "CHORE: Bump {{SUBMODULE_DIR}} to <tag-or-sha>"
```

## Clone / CI

```bash
git clone --recurse-submodules <url>
# or
git submodule update --init --recursive
```

## Enforcement

`tooling/git-hooks/pre-commit-submodule-guard.sh` in this library blocks commits that stage files inside the submodule (deletes allowed for a one-time vendor → submodule migration) and blocks commits while the submodule working tree is dirty. Enable with `git config core.hooksPath .githooks`.
