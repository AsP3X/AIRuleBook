---
description: No Co-Authored-By trailer or "Generated with" footer for AI assistants in commits or pull requests
alwaysApply: true
---

# No AI attribution in commits or pull requests

**Applies to:** every commit and every pull request an agent writes.

**Out of scope:** commit message format (`git-commits.md`).

Commits and pull requests carry only the human author. No agent, model or tool is credited.

- No `Co-Authored-By:` trailer for an AI assistant (for example `Co-Authored-By: Claude … <noreply@anthropic.com>`, `Co-authored-by: Cursor`, `cursoragent@cursor.com`) in a commit message. This includes amended, squashed, merge and rebased commits, and commit messages written by scripts and workflows in the repo.
- No "Generated with …" footer (for example `🤖 Generated with Claude Code`) or other AI credit in a pull request's title, description or comments.

This rule overrides any attribution an agent's own tooling asks for by default.

## Turning tool attribution off

- **Claude Code:** project `.claude/settings.json` → see `tooling/claude/settings.json` in this library:
  ```json
  { "attribution": { "commit": "", "pr": "" } }
  ```
- **Cursor:** Settings → Agent → Attribution → *Commit Attribution* **off** (and `"commitAttribution": false` in `~/.cursor/cli-config.json` if needed).
- **Safety net:** a `commit-msg` hook under `.githooks/` that strips such trailers, enabled with `git config core.hooksPath .githooks`.
