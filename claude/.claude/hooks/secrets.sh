#!/usr/bin/env bash
# PreToolUse hook (Edit|Write|MultiEdit): hard-block writes whose content
# matches a known secret/API-key format. Unlike git.sh, this never downgrades
# to "ask" — a leaked credential must never land on disk.
set -euo pipefail

input="$(cat)"
tool_name="$(jq -r '.tool_name // empty' <<<"$input")"

case "$tool_name" in
Write)
  content="$(jq -r '.tool_input.content // empty' <<<"$input")"
  ;;
Edit)
  content="$(jq -r '.tool_input.new_string // empty' <<<"$input")"
  ;;
MultiEdit)
  content="$(jq -r '[.tool_input.edits[]?.new_string] | join("\n")' <<<"$input")"
  ;;
*)
  exit 0
  ;;
esac

[ -z "$content" ] && exit 0

# Vendor-specific formats: low false-positive rate, unlike generic
# "password=..." heuristics, so no allowlist/override is provided.
patterns=(
  'AKIA[0-9A-Z]{16}'                                  # AWS access key
  'ASIA[0-9A-Z]{16}'                                  # AWS temporary key
  'sk-ant-[A-Za-z0-9_-]{20,}'                         # Anthropic
  'sk-[A-Za-z0-9]{20,}'                               # OpenAI
  'AIza[0-9A-Za-z_-]{35}'                             # Google API key
  'ghp_[A-Za-z0-9]{36}'                               # GitHub personal token
  'gho_[A-Za-z0-9]{36}'                               # GitHub OAuth token
  'github_pat_[A-Za-z0-9_]{22,}'                      # GitHub fine-grained PAT
  'glpat-[A-Za-z0-9_-]{20}'                           # GitLab token
  'xox[baprs]-[A-Za-z0-9-]{10,}'                      # Slack token
  'hooks\.slack\.com/services/[A-Za-z0-9/]+'          # Slack webhook
  'sk_live_[A-Za-z0-9]{24,}'                          # Stripe secret key
  'rk_live_[A-Za-z0-9]{24,}'                          # Stripe restricted key
  'SG\.[A-Za-z0-9_-]{22}\.[A-Za-z0-9_-]{43}'          # SendGrid
  'npm_[A-Za-z0-9]{36}'                               # npm token
  'dapi[A-Za-z0-9]{32}'                               # Databricks
  'r8_[A-Za-z0-9]{37}'                                # Replicate
  'gsk_[A-Za-z0-9]{20,}'                              # Groq
  'tgp_v1_[A-Za-z0-9_-]{20,}'                         # Together AI
  'fw_[A-Za-z0-9]{20,}'                               # Fireworks AI
  'hf_[A-Za-z0-9]{34}'                                # Hugging Face
  '-----BEGIN[ A-Z]*PRIVATE KEY-----'                 # PEM private key
  'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' # JWT
)

for pattern in "${patterns[@]}"; do
  if grep -Eq -- "$pattern" <<<"$content"; then
    echo "Blocked: content matches a known secret pattern ($pattern)" >&2
    exit 2
  fi
done

exit 0
