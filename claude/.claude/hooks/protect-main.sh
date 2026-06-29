#!/usr/bin/env bash
# PreToolUse hook (Bash): refuse `git commit` / `git push` while on main/master.
# Only governs Claude; you can always do it yourself in the terminal.
set -euo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
[[ -n "$cwd" && -d "$cwd" ]] && cd "$cwd"

# Only care about commit / push.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(commit|push)' || exit 0

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
case "$branch" in
  main|master)
    echo "🛑 protect-main: refusing 'git commit/push' on '$branch'. Create a feature branch first: git switch -c <name>" >&2
    exit 2 ;;
esac
exit 0
