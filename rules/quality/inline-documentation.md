---
description: Mandatory inline comments on new or modified code — a human line plus a dense "Agent:" line for non-trivial behavior
globs: "**/*.{rs,ts,tsx,swift,kt,go,py}"
alwaysApply: true
---

# Inline documentation (required)

**Applies to:** new or modified source code. Narrow the `globs` to your stack (the originals used `*.rs`, `*.{rs,ts,tsx}` and `*.{rs,swift}`). Not for configs, lockfiles, CI or env samples unless the user asks.

**Out of scope:** README, API docs, ADRs and changelogs (`docs-upkeep.md`).

**Origin:** `nebular-os`, `ownly`, `shroud` (`inline-documentation.mdc`) — merged.

**All new or modified code must include clean, human-readable inline comments.** Where behavior is non-trivial, each such comment also gets an **`Agent:` line** so agents can parse intent quickly — unless that line would be redundant. Undocumented logic is not shippable.

## What to comment

- **Every non-trivial module, function, handler, hook, component, actor or view model:** purpose and, where useful, inputs/outputs and side effects.
- **Non-obvious logic:** *why*, not what the syntax already says. Edge cases, ordering constraints, async/I/O quirks.
- **Security-sensitive code:** which secrets/keys are touched and where they are allowed to flow.
- **Sections in longer files:** short header comments before logical blocks.
- **Magic numbers, flags and workarounds:** name the intent or the constraint.

## The paired lines

| Language | Form |
|---|---|
| Rust, TypeScript, Swift, Kotlin, Go, C-likes | `// Human: …` and `// Agent: …` |
| TSX/JSX inside markup | `{/* Human: … */}` and `{/* Agent: … */}` |
| Python, shell, YAML | `# Human: …` and `# Agent: …` |

The **Human** line is conversational. The **Agent** line is factual and keyword-dense: contracts (pre/post), inputs/outputs, HTTP status paths, DB tables, env vars, invariants, failure modes, dependencies. Preferred tokens: `READS`, `WRITES`, `CALLS`, `RETURNS`, `EMITS`, `REQUIRES`, `HTTP`, `DB`.

```rust
// Human: We reject the upload early if the stream exceeds the configured body limit.
// Agent: READS MAX_BODY_SIZE via LimitReader; RETURNS 413 on overflow; WRITES temp file only after size check.
```

## Style

- Place comments **above** the code they describe (end-of-line only for very short notes).
- Public API summaries keep the language's doc comments (`///`, JSDoc, KDoc). The `Human:`/`Agent:` pair is for implementation bodies — do not put dense Agent tokens into user-facing docs.
- **Keep comments current.** A stale comment is a bug.

## Out of scope

- Do not comment every obvious line (trivial getters, pass-throughs). **Do** comment anything another developer would need to edit safely.

If code would otherwise ship undocumented, write the comments first, then keep the code aligned with them.
