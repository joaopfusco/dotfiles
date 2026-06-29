---
paths:
  - "**/flake.nix"
  - "**/devenv.{nix,yaml}"
  - "**/.envrc"
  - "**/.devcontainer/**"
  - "**/Dockerfile"
  - "**/{docker-compose,compose}*.{yml,yaml}"
---

# Dev environments

> Generic defaults. The actual setup varies per repo — detect and follow it.

Many repos ship a reproducible dev environment. Detect it and run tooling inside it
instead of installing toolchains globally:

- **Nix flakes** — `flake.nix` (+ `flake.lock`); shell via `nix develop` or direnv.
- **devenv** — `devenv.nix` / `devenv.yaml`.
- **devcontainers** — `.devcontainer/` (`devcontainer.json`).
- **direnv** — `.envrc` (often `use flake` / `use devenv`); needs `direnv allow`.

Guidelines:

- If a dev shell is defined, assume it provides the toolchain; don't reinstall things
  globally or with a different package manager.
- Keep environment definitions minimal and pinned; update inputs deliberately and
  commit the lockfile.
- Don't leak build-time deps into runtime closures/images.
- After adding files to a GNU Stow package, re-stow it (`stow -R <pkg>`).

<!-- Per-repo: which tool, shell layout, services, CI specifics. -->
