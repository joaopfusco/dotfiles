#!/usr/bin/env bash
# PostToolUse hook (Bash): append every command Claude runs, plus a snippet of
# its result, to a local audit log. Log lives outside the dotfiles repo
# (~/.claude/logs), so it is never committed.
set -euo pipefail

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
result="$(jq -r '.tool_result.text // empty' <<<"$input" | tr '\n' ' ' | cut -c1-200)"

log_dir="$HOME/.claude/logs"
mkdir -p "$log_dir"
printf '%s\t%s\t%s\t%s\n' "$(date -Is)" "${cwd:-?}" "$command" "$result" >>"$log_dir/commands.log"
exit 0
