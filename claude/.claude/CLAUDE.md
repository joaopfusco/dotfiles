# Global instructions

This is my **global** Claude Code config (managed in my dotfiles, symlinked to
`~/.claude`). Keep everything here generic so it fits every repo — including ones
that don't exist yet. Anything specific (versions, frameworks, layout, formatting,
commands) belongs in that repo's own `.claude/` and `CLAUDE.md`, which override this.

When scaffolding a repo's own `.claude/` (e.g. via `/init`), keep it **lean**: only
repo-specific facts and overrides (build/test commands, architecture, deviations).
Don't copy these global rules into a repo — they already load everywhere.

Global skills/commands here are prefixed `global-` (e.g. `/global-review-diff`).
Skills resolve user-over-project (the opposite of most config), so a same-named
global skill would silently shadow a repo's or a built-in one — the prefix avoids
that. New global skills/commands should keep the prefix. (Agents don't need it:
they resolve project-over-user.)

## Language

- Reply to me in **Brazilian Portuguese**.
- Keep code, identifiers, commit messages, branch names, and config/doc files in
  **English** — unless a file is already written in Portuguese, then match it.

## About me

Full-stack / systems engineer. I work across several languages and stacks, and the
mix changes per repo and over time — don't assume, check the repo. Languages I use
regularly include Go, Python, C#/.NET, TypeScript/React, and Rust, among others.

- Dev environments are often reproducible shells (Nix flakes, sometimes `devenv` or
  devcontainers) wired with direnv. When one exists, run tools inside it.
- Local services and databases are usually run via Docker / Docker Compose.
- My dotfiles — including this Claude Code config — are managed with GNU Stow.

## How I like to work

- Be concise and direct. Prefer the smallest change that solves the problem.
- Match the conventions already in the file/repo before introducing new ones.
- Don't add dependencies without asking; prefer the stdlib or libs already present.
- Don't commit or push unless I ask. Never commit secrets.
- The default branch (`main`/`master`) is off-limits by default: branch off it instead
  of committing there. Commit or push **directly to the default branch only when I
  clearly and explicitly authorize that specific action** — never assume it.
- Commit messages: English, Conventional Commits style, **no `Co-Authored-By` trailer**.
- When a reproducible dev shell exists (`flake.nix`, `devenv.nix`, `.devcontainer`,
  `.envrc`), assume tooling runs inside it; don't install toolchains globally.
- Don't reformat code wholesale and don't introduce a formatter/linter the repo
  hasn't adopted. Formatting policy is decided per repo, not here.
- Ask before large refactors, schema changes, or destructive operations.

## Conventions (`~/.claude/rules/`)

Generic conventions live in `~/.claude/rules/` and load automatically. They are
defaults — a repo's own `CLAUDE.md`/rules override them.

- Always loaded (universal): `code-style.md`, `security.md`.
- Path-scoped (load only when I touch matching files, via `paths:` frontmatter):
  `testing.md`, `api-conventions.md`, `dev-environments.md`, and `languages/*.md`
  (go, python, dotnet, typescript-react, rust).

## Tooling

- LSPs are available (pyright, typescript, gopls, csharp, rust-analyzer) — use them
  when present.
- Don't run formatters by default; follow whatever the repo has configured.
