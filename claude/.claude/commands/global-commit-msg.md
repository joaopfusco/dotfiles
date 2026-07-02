---
description: Draft a commit message from the current diff (suggest only, don't commit)
argument-hint: "[split] [path | staged | empty for working diff]"
---

Draft a commit message for: **$ARGUMENTS** (if empty, use the staged changes when any
exist, otherwise the full working diff). The word `split` anywhere in the arguments is
a flag, not a scope — strip it before resolving the scope.

Do **not** commit. Only suggest the message text. Then:

1. Inspect the scope with `git diff` / `git status` and skim `git log` to match the
   repo's existing commit style (Conventional Commits prefix, tense, language).
2. **Default to a single commit** covering the whole scope. Only propose multiple
   commits when I pass `split`. Without `split`, give exactly one message — even if the
   diff spans unrelated concerns; in that case add one line noting a split is possible
   (run again with `split`), but still produce the single message.
3. For each suggested message: a concise subject line, and a body explaining **why**
   when the change isn't self-evident. Keep it in English (or match the repo if its
   history is in another language). **No `Co-Authored-By` trailer.**

After presenting, offer to make the commit(s) if I confirm. Only then commit — and if
I'm on the default branch (`main`/`master`), create a feature branch first by default.
Commit or push directly to the default branch only if I clearly authorize it; when I
do, prefix the git command with `CLAUDE_ALLOW_MAIN=1` so the protect-main hook allows
it. Never push unless I ask.

Respond in Brazilian Portuguese.
