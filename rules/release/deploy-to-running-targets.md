---
description: A change that must run somewhere is not done until every running target (server, client, device) runs it — verified by the running version, not the source tree
alwaysApply: true
---

# Deploy to every running target before you stop

**Applies to:** changes to code that only matters once it is loaded by a running process somewhere else — a game/server mod, a plugin, a container image, a client bundle, firmware, a device app.

**Out of scope:** deploying to production or shared systems, which needs approval (`external-actions.md`), version numbers (`release-versioning-needs-approval.md`).

**Customize:** fill the target table with the deploy command and the proof for each target.

When the user changes such code, **every target must be running that same code before you stop.** Packaging, staging, writing a rule, or "the version string did not move" are **not** a deploy. Do not leave "restart it later" for the user.

| Target | Deploy command | Proof it is running the new code |
|---|---|---|
| {{TARGET}} (e.g. server container) | {{CMD}} (e.g. `docker compose up -d --build --force-recreate api`) | {{PROOF}} (e.g. boot log line `Initializing … vX.Y`; a state file reporting `"version":"X.Y"`) |
| {{TARGET}} (e.g. desktop client) | {{CMD}} (e.g. `make client-seed`) + user fully quits and relaunches | {{PROOF}} (e.g. the folder the client loads **first** contains the new tree) |

## Lessons baked into this rule

- **`restart` ≠ rebuild.** If the code is baked into an image, a restart runs the old image. Rebuild **and** recreate.
- **Know which copy actually loads.** Runtimes often have a search order (e.g. upload folder → package cache → local mods). Seeding a copy that loses the search order looks like a deploy and silently reverts. Remove stale shadow copies.
- **Updaters can overwrite your build.** A package manager/store update on restart can replace a newer local build with the last published one; seed after it, or pin.
- **Verify the running process, not the tree:** check the boot log, a runtime-reported version, or the UI that displays it.
- Disconnect/reconnect often keeps old client code — a full restart of the client may be required; tell the user.
