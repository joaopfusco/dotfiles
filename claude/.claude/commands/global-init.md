---
description: Scaffold a lean repo-specific .claude/ (CLAUDE.md + settings + structure)
argument-hint: "[empty | subpath to focus on]"
---

Scaffold a **lean, repo-specific** `.claude/` for this project. Focus: **$ARGUMENTS**
(if empty, the whole repo). Richer than the built-in `/init`: it also sets up
`.claude/` structure — but stays minimal and never duplicates my global config.

## 1. Analyze the repo (detect, don't assume)

- **Stack / package managers:** `package.json`, `pyproject.toml`/`requirements*.txt`,
  `go.mod`, `Cargo.toml`, `*.csproj`/`*.sln`, etc.
- **Commands:** the canonical build / test / lint / run. Read `package.json` scripts,
  `Makefile`, `justfile`, `Taskfile`, `pyproject` (hatch/poe), `go`/`cargo`/`dotnet`
  conventions. Cross-check `.github/workflows` for the commands CI actually runs.
- **Dev environment:** `flake.nix` / `devenv.nix` / `.devcontainer` / `.envrc`. If one
  exists, commands must run **inside it** — record that.
- **Architecture:** top-level layout, entry points, key modules/packages, services
  (`compose.yml`), and the existing formatter/linter/test framework.

## 2. Write a lean `CLAUDE.md`

Repo-specific facts **only**: what the project is, exact build/test/lint/run commands
(inside the dev shell when present), an architecture map (key dirs + entry points), and
any **deviations** from my global defaults. Do **not** restate the rules in
`~/.claude/rules/` — they already load everywhere. If a `CLAUDE.md` already exists,
update it in place; don't clobber unrelated content.

## 3. Scaffold `.claude/`

- **`.claude/settings.json`** — a **conservative** `permissions.allow` list for this
  project's safe, frequent commands, scoped tightly (e.g. `Bash(npm run test:*)`,
  `Bash(go test:*)`, `Bash(cargo build:*)`), plus an empty `env` stub for repo-wide
  vars. **No hooks, no plugins, nothing personal** — those live in my global config.
- **`.gitignore`** — ensure `.claude/settings.local.json` (my personal overrides) is
  ignored. Append the entry, creating `.gitignore` if absent.
- **`.claude/commands/` and `.claude/rules/`** — create these **only if** you have a
  concrete repo-specific command or path-scoped rule to put in them right now.
  Otherwise don't make empty dirs; just list them as optional next steps.

## 4. Confirm before writing

Show a short plan first: the files you'll create/update and the exact
`permissions.allow` entries (permissions are security-relevant — I review them). Only
write after I confirm.

Respond in Brazilian Portuguese.
