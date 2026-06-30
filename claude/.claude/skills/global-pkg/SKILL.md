---
name: global-pkg
description: Universal package manager. Use when I ask to install, update, remove/uninstall, or list an app/program/package/tool/CLI on this machine. Orchestrates the system's existing managers (apt, dnf, pacman, snap, flatpak, nix, brew, cargo, …) following a configurable preference hierarchy. Suggests commands and waits for confirmation — never runs anything on its own. Also handles "refresh" (re-research a method) and "re-detect" (re-scan the environment).
---

# Universal package manager

Orchestrate the package managers already on this machine to install, update, and
remove software, following the user's preference hierarchy. **Suggest, never
auto-run.** Always present the command(s) and wait for explicit confirmation before
executing anything — especially anything needing `sudo`/root. This is the core
safety contract; do not break it even if the user says "just do it" without seeing
the command first.

## Paths

- **Config (versioned, in dotfiles):** `~/.claude/skills/global-pkg/config.md` —
  the preference hierarchy and per-OS overrides. Read it at the start of every run.
- **State (per-machine, NOT in git):** `~/.local/state/global-pkg/`
  - `environment.json` — detected OS/distro and available managers, with `detected_at`.
  - `installs.jsonl` — one JSON object per install (the receipt log + short-term cache).

  Create the state dir if missing. Never write state into the dotfiles repo.

## On every run

1. Read `config.md` for the active hierarchy.
2. Load `environment.json`. If it's missing, run **environment detection** (below) once.
   Don't re-detect on every run — the environment rarely changes.

## Commands

The user speaks naturally ("install ripgrep", "remove docker"); map intent to one of:

| Command | Aliases | What it does |
|---|---|---|
| `install <app>` | add, get | Suggest how to install, following the hierarchy. |
| `remove <app>` | uninstall, delete | Reverse the install from its receipt (see **Remove**). |
| `update [<app>]` | upgrade, check | Check/upgrade out-of-band installs; all of them if no app given. |
| `list` | ls, status | Show what this skill installed, from `installs.jsonl` (app, method, date). |
| `info <app>` | show | Print the app's receipt: method, command, side effects, when. |
| `re-detect` | rescan | Re-run environment detection and overwrite `environment.json`. |

**Modifiers** (combine with any command above):

- `refresh` / `force` — ignore the cached receipt and **re-research from scratch**,
  even if a fresh receipt exists within TTL. Use when the user suspects the cached
  method is stale.

Unrecognized verb → ask which command was meant; don't guess and run something.

## Environment detection

Detect the OS once and cache it. Read `/etc/os-release` for distro + version, then
probe which managers exist (only record the ones actually present):

`dpkg`/`apt`, `dnf`/`yum`, `pacman`, `zypper`, `apk`, `snap`, `flatpak`, `nix`/`nix-env`,
`brew`, `cargo`, `pipx`, `npm`. Write the result to `environment.json` with a
`detected_at` timestamp. Re-run this only when the user says "re-detect" or after they
tell you a new manager was installed.

## Install

1. Determine the **recommended method** by walking the hierarchy in `config.md`
   (default: ① official dev/docs method → ② native system manager → ③ other available
   managers). Skip tiers whose manager isn't in `environment.json`.
2. **Research only when uncertain.** For common, stable packages you already know the
   current method for, use that knowledge. Use `WebSearch`/`WebFetch` when: the app's
   recommended install may have changed, you're unsure, it's niche, or the user asked
   to "refresh" it. Never trust a stale static guess for tier ① (official method).
3. Before searching, check `installs.jsonl` for a recent receipt of the same app
   (TTL from config, default 14 days) and reuse it unless the user forces a refresh.
4. Present using the **standard response format** (below) and wait for the user's pick.
5. Only after confirmation, run the chosen command.
6. On success, **append a receipt** to `installs.jsonl` (schema below).

## Standard response format

Every command that would run something (install, remove, update) presents its plan in
this exact shape, so the user always knows where to look and how to choose:

```
📦 <app> — <install | remove | update>   [source: cache <date> | researched]

Primary  (tier <n>, <manager>):
  <command>
Side effects: <none | repo added, GPG key, curl|sh, sudo …>

Alternatives:
  1. (<manager>)  <command>
  2. (<manager>)  <command>

[y] run primary · [1-N] pick alternative · [r] refresh (re-research) · [n] cancel
```

Rules for the format:

- Always show the action footer verbatim — `y` / number / `r` / `n` are the only inputs.
- `[n] cancel` does nothing and runs nothing. Honor it immediately.
- `[r] refresh` re-runs the research ignoring the cache, then re-prints this block.
- Show 2–4 alternatives when real ones exist; if there's genuinely only one method,
  say so instead of padding the list.
- Tag the source: `cache <date>` when reused from a receipt, `researched` when freshly
  fetched. Flag `curl | sh` and any `sudo`/root step explicitly as higher-risk.
- For `remove`, "Primary" is the reversal plan and side effects are what gets undone.

## Update / check

Apps from GUI managers (snap, flatpak) and the base system self-update via their own
flows — don't duplicate those. The real blind spot is what this skill installs
out-of-band (loose `.deb`, `curl | sh` scripts). On "update" / "check updates", scan
`installs.jsonl` for entries whose `method` has no auto-update, and for each suggest
how to check/upgrade it. Confirm before running.

## Remove / uninstall

1. Look up the app in `installs.jsonl` to recover exactly how it was installed.
2. Build a reversal plan from the receipt and present it before doing anything:
   - The uninstall command for the recorded `method` (prefer `purge`-style when the
     manager supports it).
   - Each recorded side effect, reversed: remove the added apt source
     (`/etc/apt/sources.list.d/…`), the imported GPG key (`/etc/apt/keyrings`/
     `trusted.gpg.d`), etc.
   - Leftover user config (`~/.config/<app>`, caches) — list it and remove **only with
     explicit confirmation**; never delete user data silently.
3. If there's no receipt (installed before this skill, or by hand), say so and fall
   back to detecting the manager that owns it; don't pretend the reversal is complete.
4. After a successful removal, mark or remove the receipt so it's not double-counted.

## Receipt schema (`installs.jsonl`, one JSON object per line)

```json
{
  "app": "ripgrep",
  "method": "apt",
  "command": "sudo apt install ripgrep",
  "tier": 2,
  "installed_at": "2026-06-30T14:00:00Z",
  "side_effects": [
    {"type": "apt_source", "value": "/etc/apt/sources.list.d/example.list"},
    {"type": "gpg_key", "value": "/etc/apt/keyrings/example.gpg"}
  ],
  "notes": ""
}
```

Use `side_effects: []` when there are none. `type` values seen in practice:
`apt_source`, `gpg_key`, `repo` (other managers), `script` (`curl | sh`), `config_dir`.
