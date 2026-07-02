---
name: global-dev-env
description: Scaffold a reproducible dev environment (Nix flake, devenv, or devcontainer) wired with direnv. Use when setting up a repo's toolchain or adding a dev shell.
---

# Dev environment scaffold

Set up a reproducible dev shell for a repo. Pick the approach the user prefers (ask if none):

- **Nix flake** — `flake.nix` with `devShells.default` + `.envrc` (`use flake`).
- **devenv** — `devenv.nix` (+ `devenv.yaml`) + `.envrc` (`use devenv`).
- **devcontainer** — `.devcontainer/devcontainer.json` (features or a Dockerfile).

## Steps

1. Confirm the approach and detect the stack from markers (`go.mod`, `pyproject.toml`,
   `*.csproj`, `package.json`, `Cargo.toml`, …). Ask if ambiguous.
2. Scaffold with the tool's initializer (`nix flake init`, `devenv init`, or write the
   file directly), then trim to just what the project needs (toolchain, LSP, formatter,
   required services). Pin `nixpkgs`.
3. Wire direnv when relevant: `.envrc` (`use flake`/`use devenv`); tell the user to run
   `direnv allow`. (`devenv init` writes `.envrc` already.)
4. Update `.gitignore` (`.direnv/`, `.devenv/`, artifacts) and commit the lockfile.
5. Verify tools resolve inside the shell (`nix develop -c <tool> --version`, `devenv
   shell`, or reopen in container).

Keep it minimal and specific: a dev shell, not a production build. Don't leak build-time
deps into runtime. After adding files to a Stow package, remind to `stow -R <pkg>`.
