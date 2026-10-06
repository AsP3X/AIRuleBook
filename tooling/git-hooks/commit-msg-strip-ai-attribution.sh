#!/bin/sh
# Human: Remove AI co-author trailers and "Generated with" footers from commit messages.
# Agent: RUNS as commit-msg hook (core.hooksPath=.githooks); REWRITES $1 in place; never fails the commit.
#
# Safety net for rules/git/no-ai-attribution.md. Install: copy to <repo>/.githooks/commit-msg,
# chmod +x, then: git config core.hooksPath .githooks

msg_file="$1"
[ -f "$msg_file" ] || exit 0

tmp="${msg_file}.strip-ai.$$"
# Agent: DROPS lines matching known AI attribution patterns (case-insensitive); KEEPS everything else.
grep -viE '^(co-authored-by:.*(claude|anthropic|cursor|copilot|openai|chatgpt|codex|gemini|grok|devin|aider))|generated with \[?(claude|cursor|copilot|codex|gemini)|^🤖' "$msg_file" > "$tmp" || true

# Human: Trim trailing blank lines the removal may leave behind.
# Agent: READS tmp; WRITES msg_file without trailing empty lines.
awk '{ lines[NR] = $0 } END { n = NR; while (n > 0 && lines[n] ~ /^[[:space:]]*$/) n--; for (i = 1; i <= n; i++) print lines[i] }' "$tmp" > "$msg_file"
rm -f "$tmp"
exit 0
