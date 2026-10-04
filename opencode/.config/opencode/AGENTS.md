# OpenCode Context

## Preferences
- Ask before committing to git
- Prefer editing existing files over creating new ones
- Run tests after making changes
- Keep code simple — no over-engineering

## Environment
- Dotfiles are managed with GNU Stow from `~/dotfiles` (one package per program)
- Config files under `$HOME` are often symlinks into `~/dotfiles` — edit the file in that repo, not a copy

## Language
- Code, identifiers, documentation, comments, and commit messages: always in English
- Chat explanations: always in Portuguese

## Comments (strict)
- Default: write NO comments. Code and names must explain themselves.
- Allowed: one single-line comment explaining a non-obvious *why*. Never multi-line comment blocks, file headers, or docstrings narrating behavior.
- Do not imitate verbose comments already in a file.
- Bad: `# Loop over users and send each one an email, skipping inactive ones`
- Good: `# API rejects batches > 100`

## Commits
- Use Conventional Commits format (`feat:`, `fix:`, `refactor:`, etc.)
- Never add a `Co-Authored-By` trailer or any other co-author attribution to commit messages

## Sourcing
- Always state the source of any information given, and verify it before asserting it

## Tooling
- Use CLI tools (`gh`, `aws`, `gcloud`, etc.) for external services instead of raw API calls, when available
- Before installing or using a tool/language version globally, check if the repo defines a dev environment (`devenv.nix`, `flake.nix`, `.devcontainer/`, `shell.nix`, `.envrc`) and use that instead (`nix develop`, `devenv shell`, etc.)
- Don't add packages to a global/user profile to satisfy a per-repo need — add them to the repo's own dev environment file
- For one-off scripts (e.g. Python with dependencies), reach for Nix before global `pip`/`npm install`/etc: `nix shell`/`nix run` for throwaway use, `devenv.nix`/`flake.nix` if it's project-scoped and reusable

## Workflow
- When something goes sideways, stop and re-plan — don't keep pushing
- After finishing a task: run typecheck, tests, and lint before calling it done
- Show evidence of completion (test output, command run) rather than just asserting a task is done
- When compacting, always preserve the full list of modified files and any test commands

## Style
- Prefer small, focused functions
- Use early returns over nested conditionals