---
name: global-pkg
description: Install, update, remove/uninstall, or list apps/packages on this machine. Orchestrates the system's package managers (apt, snap, flatpak, nix, brew, …) by a configurable hierarchy; suggests commands and waits for confirmation, never runs on its own.
---

# Universal package manager

Orchestrate the machine's package managers to install/update/remove software by the
user's hierarchy. **Suggest, never auto-run**: present the command(s) and wait for
confirmation before running anything — especially `sudo`.

## Paths

- **Config** (versioned): `~/.claude/skills/global-pkg/config.md` — hierarchy + TTL. Read every run.
- **State** (per-machine, not git): `~/.local/state/global-pkg/` — `environment.json`
  (OS + managers) and `installs.jsonl` (one receipt per install). Create if missing.

## Every run

Read `config.md`. Load `environment.json`; if missing, run detection once (below).

## Commands

| Command | Aliases | Does |
|---|---|---|
| `install <app>` | add, get | Suggest install per hierarchy. |
| `remove <app>` | uninstall, delete | Reverse the install from its receipt. |
| `update [<app>]` | upgrade, check | Check/upgrade out-of-band installs (all if no app). |
| `list` | ls, status | List installs from `installs.jsonl`. |
| `info <app>` | show | Print the app's receipt. |
| `re-detect` | rescan | Re-run detection, overwrite `environment.json`. |

Modifier `refresh`/`force` (any command): ignore the cached receipt, re-research from
scratch. Unknown verb → ask, don't guess.

## Environment detection

Read `/etc/os-release` for distro+version; probe which managers exist (`apt`, `dnf`,
`pacman`, `zypper`, `apk`, `snap`, `flatpak`, `nix`, `brew`, `cargo`, `pipx`, `npm`).
Record only those present, with `detected_at`. Re-run only on `re-detect`.

## Install

1. Pick the method by walking `config.md`'s hierarchy (default: ① official dev/docs →
   ② native manager → ③ others), skipping tiers whose manager is absent.
2. Research (`WebSearch`) only when uncertain — method may have changed, niche app, or
   `refresh`. Never trust a stale guess for tier ①.
3. Reuse a receipt within TTL unless `refresh`.
4. Present in the standard format; run only the chosen command; append a receipt on success.

## Standard response format

```
📦 <app> — <install|remove|update>   [source: cache <date> | researched]

Primary (tier <n>, <manager>):
  <command>
Side effects: <none | repo, GPG key, script, sudo …>

Alternatives:
  1. (<manager>)  <command>
  2. (<manager>)  <command>

[y] run · [1-N] alternative · [r] refresh · [n] cancel
```

- Show the footer verbatim; `[n]` runs nothing.
- 2–4 alternatives when real; if there's only one method, say so.
- An official install that's a script (`curl | sh`) or needs `sudo` is fine — just
  record it as a `script` side effect so removal can undo it. Don't deprioritize it.
- For `remove`, Primary is the reversal plan; side effects are what gets undone.

## Remove

1. Find the app in `installs.jsonl` to recover how it was installed.
2. Present a reversal plan: the uninstall command (prefer `purge`), plus each recorded
   side effect reversed (apt source, GPG key, added repo). Leftover user config
   (`~/.config/<app>`) removed **only with confirmation** — never delete data silently.
3. No receipt (installed by hand) → say so, fall back to the owning manager; don't
   claim a complete reversal.
4. Drop the receipt after removal.

## Receipt schema (`installs.jsonl`, one object per line)

```json
{"app":"ripgrep","method":"apt","command":"sudo apt install ripgrep","tier":2,
 "installed_at":"2026-06-30T14:00:00Z","side_effects":[],"notes":""}
```

`side_effects[].type`: `apt_source`, `gpg_key`, `repo`, `script`, `config_dir`.
