# Brief for every agent on {{WORKSTREAM}} (read fully before working)

<!--
Template for briefing parallel/sub-agents on a large multi-agent job (a port, a migration, a wave of
work packages). Pairs well with an orchestration that runs each package in its own worktree, then
merges, integrates, runs acceptance, does an adversarial review and applies fixes.
-->

You are a {{ROLE}} (e.g. "UI engineer"). You implement exactly **one** work item — your prompt names
it. Ownership is split: **you own {{YOUR_AREA}} only; {{OTHER_OWNER}} owns {{OTHER_AREA}}.** Never
cross the boundary "helpfully".

## Sources (read the parts your item needs)

- `AGENTS.md` and the rules it links.
- The plan: `{{PLAN_PATH}}` — sections {{SECTIONS}}.
- Contracts between owners: `{{CONTRACTS_PATH}}`. Where two documents disagree, **{{WHICH_WINS}}** is what the code does.
- Reference implementation(s): `{{REFERENCE_DIR}}` — port behaviour, copy, spacing, colours and states 1:1; cite the reference `file:line` in doc comments for ported behaviour.

## Paths

**Allowed:**
- `{{ALLOWED_GLOB_1}}`
- `{{ALLOWED_GLOB_2}}`

**Forbidden:**
- `{{FORBIDDEN_GLOB_1}}` (owned by {{OTHER_OWNER}})
- build files, manifests, CI
- design files (only the design item edits them — see Design)
- agent config (`.claude/**`, `.cursor/**`)
- read-only branches: `{{READ_ONLY_BRANCHES}}`

## Contract rules (enforced by review)

- **Threading / errors / auth / adapters:** {{CONTRACT_RULES}}
- **No deprecated APIs** (`no-deprecated-apis.md`).
- **Contract gap:** if a contract lacks a member, behaviour or resource you need, **do not edit the other owner's code.** Write the gap (path, exact signature or change, why, which item needs it) into your final report, and work around it inside your own paths only if that is honest (e.g. a disabled state). Otherwise leave that part out.

## Build and test

- Build through `{{BUILD_WRAPPER}}` (it rations machine-wide build slots — waiting is normal). Never call the raw build tool directly.
- **Your gate:** `{{GATE_TASKS}}` green before your final report. While iterating, run narrower tasks.
- Lint adds no new warnings in your files.
- Add tests for every rule you port; copy test vectors from the reference tests.
- Throwaway infrastructure only: your own containers/emulators/simulators on your own ports, removed when done. **Never** touch {{PROTECTED_RESOURCES}} (the owner's devices, dev databases).
- Tests that silently "skip" when a dependency is unreachable do not count — check the output for skips.

## Git (resumable work — a session can stop at any moment)

- You work in an isolated worktree on branch `{{BRANCH_PATTERN}}`.
  - If your branch already exists, it holds an interrupted earlier run: `git checkout <branch>` (never `checkout -B`), merge the current base **first**, review what is there, and continue.
  - Otherwise `git checkout -b <branch> {{BASE_BRANCH}}`.
- **Commit early and often** — after every meaningful step and before every long build. Message: one plain sentence starting `TASK: `, `FIX: ` or `ADD: `, with **no AI attribution** line.
- **Never** push, merge into shared branches, rewrite history, or commit agent config.
- Shared scratch space: prefix every file with your item id (`c8-gate.log`) — other agents overwrite generic names.

## Design

Only the design item edits design files (a shared design app would be clobbered by parallel agents).
List every visible UI state you built or changed under **DESIGN NOTES**: screen and state, exact
copy, sizes, colour tokens, the reference frame it mirrors.

## Final report (plain text, this order)

1. **SUMMARY:** what you built and what is left.
2. **BRANCH + HEAD SHA.**
3. **FILES:** grouped by directory.
4. **TESTS:** added tests and gate result, with counts.
5. **CONTRACT GAPS:** a list, or "none".
6. **DESIGN NOTES.**
7. **DEVICE / MANUAL CHECKS:** run with results, or still owed with exact steps.
8. **MERGE NOTES:** expected conflicts with other items; shared files touched.

## Updates

<!-- Append dated "Update YYYY-MM-DD HH:MM UTC" sections as the base branch moves, instead of rewriting the brief. -->
