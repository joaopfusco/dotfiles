# Code style (universal)

Language-agnostic defaults. Per-language specifics live in `languages/`.

## Naming

- Names describe intent, not type: `users`, not `userList`/`userArr`.
- Booleans read as predicates: `isEnabled`, `hasAccess`, `shouldRetry`.
- Avoid abbreviations except well-known ones (`id`, `url`, `db`, `ctx`).
- Follow each language's casing convention; don't impose one across languages.

## Structure

- Small, single-purpose functions; extract once logic is reused or hard to read.
- Keep nesting shallow — prefer early returns / guard clauses over `else` ladders.
- Order a file top-down: public/exported surface first, helpers below.
- Co-locate things that change together; split by feature, not by layer-of-the-week.

## Comments

- Explain **why**, not **what**. The code already says what.
- No commented-out code and no decorative banners — delete dead code, git remembers.
- Keep doc comments on exported/public APIs current; a wrong comment is worse than none.

## Errors

- Never swallow errors silently. Handle, wrap with context, or propagate.
- Fail fast on programmer errors; degrade gracefully on expected/runtime errors.
- Error messages state what failed and the relevant input, without leaking secrets.

## General

- No magic numbers/strings — name them.
- Prefer immutability and pure functions where it doesn't hurt clarity.
- Delete code rather than leaving it disabled behind a flag "just in case".
- Respect the repo's existing formatter/linter config; don't reformat unrelated code
  or impose a formatter the repo hasn't adopted.
