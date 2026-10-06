#!/bin/bash
# Claude Code SessionStart hook: bring a fresh session worktree level with the
# base branch and origin/<base> (rules/git/worktrees-from-base-branch.md).
# Does nothing in the main checkout or in other repositories. Whatever it
# prints on stdout reaches the agent as session context.
#
# Generalized from shroud/.claude/hooks/sync-worktree-with-dev.sh.
#
# Install: copy to <repo>/.claude/hooks/ in the MAIN checkout and register it
# in ~/.claude/settings.json (user level), pointing at that file:
#   "hooks": { "SessionStart": [ { "hooks": [ { "type": "command",
#     "command": "bash /abs/path/to/repo/.claude/hooks/sync-worktree-with-base.sh" } ] } ] }
# A worktree cut from an old commit may lack this script and the project
# settings, so a project-level hook would not run where it is needed.
#
# Base branch: BASE_BRANCH env var, default "dev". Requires jq.

base="${BASE_BRANCH:-dev}"
rule="docs/agent-rules/worktrees-from-base-branch.md"

script_dir=$(cd "$(dirname "$0")" && pwd -P)
repo_common=$(cd "$script_dir" && cd "$(git rev-parse --git-common-dir)" && pwd -P) || exit 0

dir=$(jq -r '.cwd // empty' 2>/dev/null)
cd "${dir:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0

git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null) || exit 0
common_dir=$(cd "$(git rev-parse --git-common-dir)" && pwd -P)
[ "$common_dir" = "$repo_common" ] || exit 0          # another repository
[ "$(cd "$git_dir" && pwd -P)" = "$common_dir" ] && exit 0  # main checkout, not a worktree

fetch_note=""
if ! git fetch --quiet origin "$base" 2>/dev/null; then
  fetch_note=" (git fetch origin failed; origin/$base may be stale)"
fi

target="$base"
if git rev-parse --verify --quiet "origin/$base" >/dev/null; then
  if git merge-base --is-ancestor "$base" "origin/$base"; then
    target="origin/$base"
  elif ! git merge-base --is-ancestor "origin/$base" "$base"; then
    echo "Worktree sync: local $base and origin/$base have diverged${fetch_note}. Tell the user before editing; don't merge, rebase or reset either branch ($rule)."
    exit 0
  fi
fi

if git merge-base --is-ancestor "$target" HEAD; then
  echo "Worktree sync: already up to date with $target${fetch_note}."
  exit 0
fi

if ! git merge-base --is-ancestor HEAD "$target"; then
  echo "Worktree sync: this worktree has commits that $target doesn't, so it wasn't fast-forwarded${fetch_note}. Merge $target into it before the first edit ($rule)."
  exit 0
fi

before=$(git rev-parse --short HEAD)
if git merge --ff-only --quiet "$target" >/dev/null 2>&1; then
  echo "Worktree sync: fast-forwarded this worktree from $before to $target ($(git rev-parse --short HEAD))${fetch_note}."
else
  echo "Worktree sync: fast-forward from $before to $target failed (local changes in the way?)${fetch_note}. Run git merge --ff-only $target before the first edit ($rule)."
fi
