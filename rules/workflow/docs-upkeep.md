---
description: Project documentation (README, API/protocol docs, config tables, ADRs, changelog, agent rules) is updated in the same change that makes it stale
alwaysApply: true
---

# Documentation upkeep

**Applies to:** project-level documentation — `README.md`, `docs/`, API and protocol references, configuration tables, architecture decision records, `CHANGELOG.md`, `CONTRIBUTING.md`, and the agent rules themselves.

**Out of scope:** inline code comments (`inline-documentation.md`); env var docs details (`env-config-sync.md`); commit prefix for docs-only commits (`git-commits.md` → `DOCS:`).

Docs that disagree with the code are worse than no docs: agents and people follow them. **A change that makes a doc wrong updates that doc in the same change set.**

## Update triggers

| You changed… | Update |
|---|---|
| Setup steps, prerequisites, commands, ports, scripts | `README.md` quick start / commands table |
| HTTP endpoints, request/response shapes, status codes, error codes | API docs / OpenAPI spec |
| Wire protocol, file or message formats | Protocol docs (and fixtures — `regression-testing.md`) |
| Env vars, config keys, flags | Configuration table (`env-config-sync.md`) |
| Architecture: new service, storage, major library, cross-cutting pattern | A short ADR in `docs/adr/NNNN-title.md` (context, decision, consequences) |
| User-visible behavior in a released product | `CHANGELOG.md` under *Unreleased* (Added / Changed / Fixed / Removed) |
| Repository layout or commands agents rely on | `AGENTS.md`, `project-layout` rule |
| A rule turned out wrong or incomplete | The rule file — and tell the user |

## How

- Before finishing, search docs for names you changed (`grep -rn "<old name>" docs README.md`) and fix every hit.
- Write for a new contributor: concrete commands in fenced blocks, real paths, no "as before" references.
- Don't duplicate: link to the single canonical place instead of copying content into a second doc.
- Docs-only changes are their own `DOCS:` commit unless they accompany the code change that required them.
- Don't create new documentation files nobody asked for; extend the existing ones (`scope-discipline.md`).

## Agent rules

- Agents don't silently edit rule files. When a rule blocks the task or seems wrong, say so and propose the change; edit the rule only when the user agrees.
- Keep `AGENTS.md`'s index, the rule files and `CLAUDE.md` imports consistent (one rule per file, a row and an import each).
