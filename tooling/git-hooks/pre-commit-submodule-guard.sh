#!/bin/sh
# Human: Block accidental commits of a read-only submodule's files; allow submodule pointer bumps only.
# Agent: RUNS on every commit when core.hooksPath=.githooks; FAILS on <SUBMODULE>/* paths except the gitlink itself.
#
# Generalized from ownly/.githooks/pre-commit (rules/architecture/vendored-submodule-readonly.md).
# Install: copy to <repo>/.githooks/pre-commit, set SUBMODULE (and UPSTREAM) below,
#          chmod +x, then: git config core.hooksPath .githooks

set -e

SUBMODULE="${SUBMODULE:-vendor-module}"            # e.g. nebular-os
UPSTREAM="${UPSTREAM:-the upstream repository}"    # e.g. https://github.com/<owner>/<repo>

# Human: Staging <SUBMODULE>/src/... must never land in this repo's history.
# Agent: READS cached paths; EXITS 1 if any path is <SUBMODULE>/<file> rather than the submodule entry alone.
if git rev-parse --git-dir >/dev/null 2>&1; then
  staged_paths=$(git diff --cached --name-only 2>/dev/null || true)
  deleted_paths=$(git diff --cached --name-only --diff-filter=D 2>/dev/null || true)
  for path in $staged_paths; do
    case "$path" in
      "$SUBMODULE"/*)
        # Human: A one-time vendor-to-submodule migration may stage deletes under <SUBMODULE>/*.
        # Agent: ALLOW diff-filter D only; BLOCK adds/modifies under <SUBMODULE>/*.
        if echo "$deleted_paths" | grep -Fxq "$path"; then
          continue
        fi
        echo "pre-commit: refusing to commit files under $SUBMODULE/: $path" >&2
        echo "$SUBMODULE is a read-only submodule. Apply changes in $UPSTREAM" >&2
        echo "then bump the submodule: cd $SUBMODULE && git checkout <sha> && cd .. && git add $SUBMODULE" >&2
        exit 1
        ;;
    esac
  done
fi

# Human: A dirty submodule working tree should not ship with unrelated commits.
# Agent: SKIPS when only bumping the gitlink (sole staged path is <SUBMODULE>); else FAILS on porcelain inside the submodule.
if [ -f .gitmodules ] && { [ -d "$SUBMODULE/.git" ] || [ -f "$SUBMODULE/.git" ]; }; then
  only_gitlink_bump=false
  staged_count=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  if [ "$staged_count" = "1" ] && git diff --cached --name-only 2>/dev/null | grep -qx "$SUBMODULE"; then
    only_gitlink_bump=true
  fi
  if [ "$only_gitlink_bump" = "false" ]; then
    dirty=$(git -C "$SUBMODULE" status --porcelain 2>/dev/null || true)
    if [ -n "$dirty" ]; then
      echo "pre-commit: $SUBMODULE submodule has uncommitted changes" >&2
      echo "Commit or discard them in the upstream repo, or reset: git -C $SUBMODULE checkout -- ." >&2
      exit 1
    fi
  fi
fi

exit 0
