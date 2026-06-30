---
name: global-dev-env
description: Scaffold a reproducible dev environment for a project (Nix flake, devenv, or devcontainer) and wire it with direnv. Use when setting up a new repo's toolchain or adding/adjusting a dev shell for any language.
---

# Dev environment scaffold

Set up a reproducible dev environment for a repo. Pick the approach the user prefers;
if they have no preference, ask. All three are valid:

- **Nix flake** — `flake.nix` exposing `devShells.default`, plus `.envrc` (`use flake`).
- **devenv** — `devenv.nix` (+ `devenv.yaml`), plus `.envrc` (`use devenv`).
- **devcontainer** — `.devcontainer/devcontainer.json` (features or a Dockerfile).

## Steps

1. **Confirm the approach** (Nix / devenv / devcontainer) and **detect the stack**
   from existing markers (`go.mod`, `pyproject.toml`, `*.csproj`, `package.json`,
   `Cargo.toml`, etc.). Ask if ambiguous.
2. **Scaffold** with the tool's own initializer, then edit the result down to just the
   toolchain the project needs (compiler/runtime, language server, formatter/linter,
   and any required services):
   - **Nix flake** — `nix flake init` (or write `flake.nix` directly), expose
     `devShells.default`, pin `nixpkgs`.
   - **devenv** — `devenv init` (creates `devenv.nix`, `devenv.yaml`, and an `.envrc`).
   - **devcontainer** — create `.devcontainer/devcontainer.json` using a base image +
     features, or a `Dockerfile`.
3. **Wire direnv** when relevant: an `.envrc` (`use flake` / `use devenv`); tell the
   user to run `direnv allow`. (`devenv init` already writes the `.envrc`.)
4. **Update `.gitignore`** (e.g. `.direnv/`, `.devenv/`, build artifacts) and commit
   the lockfile (`flake.lock` / `devenv.lock`).
5. **Verify** the environment builds and the tools resolve inside it
   (`nix develop -c <tool> --version`, `devenv shell`, or reopen in container).

The exact contents always depend on the project — keep them minimal and specific to
what the repo actually needs.

## Notes

- Tooling only (a dev shell), not a production build, unless the user asks otherwise.
- Don't leak build-time deps into runtime closures/images.
- After adding files to a GNU Stow package, remind to `stow -R <pkg>`.
