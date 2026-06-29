---
description: Review the current diff (or a target) against my conventions
argument-hint: "[path | commit | empty for working diff]"
---

Review the code at: **$ARGUMENTS** (if empty, review the uncommitted working diff).

Delegate to the `code-reviewer` subagent. It should:

1. Resolve the scope (working diff, staged diff, a commit, or the given path).
2. Apply my conventions in `~/.claude/rules/` (universal + the relevant language file).
3. Report findings grouped as Blocker / Should-fix / Nit, each with `file:line`,
   the problem, why it matters, and a concrete fix.

Be concise and high-signal. If nothing's wrong, say so. Respond in Brazilian Portuguese.
