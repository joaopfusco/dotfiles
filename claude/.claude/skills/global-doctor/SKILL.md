---
name: global-doctor
description: Diagnose a broken local dev environment — tools not found, wrong shell, services won't connect, "works for someone else but not me". Checks direnv/Nix/devenv/devcontainer, toolchain resolution, and Docker Compose.
---

# Dev environment doctor

Diagnose why a repo's local environment isn't working. **Read-only**: investigate
and report; propose fixes but don't apply them without asking.

## Procedure

Detect what the repo uses, then run only the relevant checks. Don't assume a stack.

1. **Shell / direnv**
   - Is there an `.envrc`? Is direnv installed (`direnv version`) and **allowed**
     (`direnv status`)? A blocked/!allowed `.envrc` means the env never loaded.
   - Confirm the expected env actually applied (e.g. project bin on `PATH`).
2. **Reproducible shell**
   - **Nix**: `flake.nix` present? `nix flake check` / `nix develop -c true` works?
     Is `flake.lock` committed and current?
   - **devenv**: `devenv.nix` present? `devenv version`; does `devenv shell -- true` work?
   - **devcontainer**: `.devcontainer/` present? Note if the user is inside it or not.
3. **Toolchain resolution**
   - For the repo's languages, check the tool resolves and the version matches what
     the project expects (`go version`, `python --version`, `dotnet --info`,
     `node --version`, `cargo --version`, etc.). Flag host-vs-shell mismatches.
4. **Services (Docker Compose)**
   - Is there a `compose.yml` / `docker-compose*.yml`? Is the daemon up
     (`docker info`)? `docker compose ps` — which services are up/exited/unhealthy?
   - For a service that won't connect, check `docker compose logs <svc>` and the
     published ports.
5. **Env files**
   - Is a required `.env` missing while only `.env.example` exists? Don't print
     secret values — just report the missing keys.

## Output

A short report grouped as **Broken** (blocking) / **Warning** / **OK**. For each
problem: what's wrong, the evidence (the command output), and the exact fix command.
End with the single most likely root cause. Ask before changing anything.
