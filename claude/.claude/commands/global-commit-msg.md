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
   history is in another language). End each message with the trailer:
   `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`

After presenting, offer to make the commit(s) if I confirm. Only then commit — and if
I'm on the default branch, create a branch first. Never push unless I ask.

Respond in Brazilian Portuguese.
