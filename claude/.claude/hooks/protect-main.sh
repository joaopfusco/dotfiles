#!/usr/bin/env bash
# PreToolUse hook (Bash): refuse `git commit` / `git push` while on main/master,
# UNLESS the command carries the explicit authorization token CLAUDE_ALLOW_MAIN=1.
# Claude only adds that token after I clearly authorize a commit/push on the default
# branch, so accidental writes to main stay blocked. Only governs Claude; you can
# always do it yourself in the terminal.
set -euo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
[[ -n "$cwd" && -d "$cwd" ]] && cd "$cwd"

# Only care about commit / push.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(commit|push)' || exit 0

# Explicit authorization bypass: I told Claude to commit/push to main for this action.
printf '%s' "$cmd" | grep -q 'CLAUDE_ALLOW_MAIN=1' && exit 0

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
case "$branch" in
  main|master)
    echo "🛑 protect-main: refusing 'git commit/push' on '$branch' without authorization. If I clearly authorized it, prefix the command with 'CLAUDE_ALLOW_MAIN=1'. Otherwise create a feature branch first: git switch -c <name>" >&2
    exit 2 ;;
esac
exit 0
