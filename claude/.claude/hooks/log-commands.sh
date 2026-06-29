#!/usr/bin/env bash
# PreToolUse hook (Bash): append every command Claude runs to a local audit log.
# Log lives outside the dotfiles repo (~/.claude/logs), so it is never committed.
set -euo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"

log_dir="$HOME/.claude/logs"
mkdir -p "$log_dir"
printf '%s\t%s\t%s\n' "$(date -Is)" "${cwd:-?}" "$cmd" >> "$log_dir/commands.log"
exit 0
