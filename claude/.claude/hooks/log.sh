#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
result="$(jq -r '.tool_result.text // empty' <<<"$input" | tr '\n' ' ' | cut -c1-200)"

log_dir="$HOME/.claude/logs"
mkdir -p "$log_dir"
printf '%s\t%s\t%s\t%s\n' "$(date -Is)" "${cwd:-?}" "$command" "$result" >>"$log_dir/commands.log"
exit 0
