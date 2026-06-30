# global-pkg config

User-editable settings for the `global-pkg` skill. Versioned in dotfiles.

## Preference hierarchy

When choosing how to install an app, walk these tiers top-to-bottom and use the first
whose manager is available on this machine. Reorder the list to change the policy.

1. **Official method** — the way the project's own devs/docs recommend (their repo,
   their script, their `.deb`/release). Highest trust for getting a working, current install.
2. **Native system manager** — the distro's own manager (`apt`/`dnf`/`pacman`/…).
3. **Other available managers** — `nix`, `brew`, `snap`, `flatpak`, `cargo`, etc.

## Per-OS overrides

Optional. Override the hierarchy for a specific OS/distro. Leave empty to use the
default above everywhere.

- _none_

## Cache TTL

How long a receipt in `installs.jsonl` is reused before re-researching the same app.

- `ttl_days: 14`
