# Global instructions

My **global** Claude Code config (dotfiles, symlinked to `~/.claude`). Keep it generic —
it fits every repo. Repo-specific facts (versions, layout, build/test commands) belong in
that repo's own `.claude/`/`CLAUDE.md`, which override this. When scaffolding a repo's
`.claude/` (e.g. `/init`), keep it lean and don't copy these global rules in — they load
everywhere.

Global skills/commands are prefixed `global-` (skills resolve user-over-project, so the
prefix avoids shadowing a repo's or built-in skill). Agents don't need it.

## Language

- Reply in **Brazilian Portuguese**.
- Code, identifiers, commit messages, branch names, config/doc files in **English** —
  unless a file is already in Portuguese, then match it.

## About me

Full-stack / systems engineer, polyglot — the stack changes per repo, so check, don't
assume. Regular: Go, Python, C#/.NET, TypeScript/React, Rust, among others.

- Dev shells are often Nix flakes (sometimes `devenv`/devcontainers) + direnv; run tools inside them.
- Local services/DBs via Docker Compose.
- Dotfiles (incl. this config) managed with GNU Stow.

## How I like to work

- Concise and direct. Smallest change that solves the problem.
- Match existing conventions before introducing new ones.
- Don't add dependencies without asking; prefer stdlib / libs already present.
- Don't commit or push unless I ask. Never commit secrets.
- Default branch (`main`/`master`) off-limits by default: branch off it. Commit/push
  directly to it **only when I clearly, explicitly authorize that action** — never assume.
- Commit messages: English, Conventional Commits, **no `Co-Authored-By` trailer**.
- When a dev shell exists, run tooling inside it; don't install toolchains globally.
- Don't reformat wholesale or introduce a formatter/linter the repo hasn't adopted.
- Ask before large refactors, schema changes, or destructive operations.

## Conventions (`~/.claude/rules/`)

Load automatically as defaults (repo overrides win):
- Always: `code-style.md`, `security.md`.
- Path-scoped (`paths:` frontmatter): `testing.md`, `api-conventions.md`,
  `dev-environments.md`, `languages/*.md`.

## Tooling

- LSPs available (pyright, typescript, gopls, csharp, rust-analyzer) — use when present.
- Don't run formatters by default; follow the repo's config.
