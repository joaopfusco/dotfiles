#!/usr/bin/env bash
# PreToolUse hook (Edit|Write|MultiEdit): block writing secrets to files.
# Reads the tool-call JSON on stdin. Exit 2 = block (stderr is shown to Claude).
set -euo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"

# Text being written across Write/Edit/MultiEdit shapes.
text="$(printf '%s' "$input" | jq -r '
  [ .tool_input.content    // empty,
    .tool_input.new_string // empty,
    (.tool_input.edits // [] | map(.new_string) | join("\n")) ] | join("\n")')"

block() { echo "🛑 block-secrets: $1" >&2; exit 2; }

base="$(basename "${file:-}")"
case "$base" in
  .env|.env.*)
    case "$base" in
      *.example|*.sample|*.template) : ;;
      *) block "writing to '$base' (env file). Keep real values out of git; use a .env.example with placeholders." ;;
    esac ;;
  id_rsa|id_dsa|id_ecdsa|id_ed25519|*.pem|*.key|*.pfx|*.p12|*.keystore|credentials.json|*-key.json)
    block "'$base' looks like a private key / credential file." ;;
esac

# Content patterns: "regex###human description" (### avoids colliding with regex chars)
patterns=(
  '-----BEGIN [A-Z ]*PRIVATE KEY-----###private key block'
  'AKIA[0-9A-Z]{16}###AWS access key id'
  'aws_secret_access_key[[:space:]]*=[[:space:]]*[A-Za-z0-9/+]{40}###AWS secret access key'
  'gh[pousr]_[A-Za-z0-9]{30,}###GitHub token'
  'xox[baprs]-[A-Za-z0-9-]{10,}###Slack token'
  'sk-[A-Za-z0-9]{20,}###OpenAI-style API key'
  'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}###JWT'
)
for p in "${patterns[@]}"; do
  re="${p%%###*}"; desc="${p##*###}"
  if printf '%s' "$text" | grep -Eq -- "$re"; then
    block "detected $desc in the content for '${base:-?}'."
  fi
done

exit 0
