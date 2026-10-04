# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a package whose contents mirror `$HOME`.

## Prerequisites

- [Homebrew](https://brew.sh) and `stow` (`brew install stow`)
- Git configured, with an SSH key registered on GitHub

```bash
ssh-keygen -t ed25519 -C "joaopedrofusco@gmail.com"
cat ~/.ssh/id_ed25519.pub # copy this to GitHub
```

```bash
git clone git@github.com:joaopfusco/dotfiles.git ~/dotfiles
```

## Initial setup

Install the apps, then link every package before opening them, so they don't create default configs that conflict with the links:

```bash
cd ~/dotfiles
stow */
```

## Day to day

Configs under `$HOME` are symlinks into this repo, so just edit the files here.

After adding a file to an existing package, or a new package (a directory mirroring `$HOME`):

```bash
stow -R */
```
