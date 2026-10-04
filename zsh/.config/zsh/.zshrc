if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

typeset -U path
path=("$HOME/.local/bin" "$HOME/.opencode/bin" "$HOME/.dotnet/tools" $path)

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

ZSH_THEME=gentoo
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

autoload -U select-word-style
select-word-style bash
bindkey '^H' backward-kill-word

alias l='eza -l'
alias ls=l
alias la='eza -la'
alias lt='eza --tree'
alias cls='clear && printf '\''\033[3J'\'''
alias ipe='curl ifconfig.me'
alias dnix-upgrade='sudo determinate-nixd upgrade'
alias dnix-version='determinate-nixd version'
alias nix-upgrade='sudo -i nix upgrade-nix'

flake-lock-age() {
  git -C "$HOME/nix-config" log -1 --format='%cd (%cr)' --date=short -- flake.lock
}

flake-lock-push() {
  git -C "$HOME/nix-config" add flake.lock &&
  git -C "$HOME/nix-config" commit -m 'chore: update flake.lock' &&
  git -C "$HOME/nix-config" push
}

flake-lock-revert() {
  git -C "$HOME/nix-config" diff --quiet -- flake.lock \
  && git -C "$HOME/nix-config" checkout HEAD~1 -- flake.lock \
  || git -C "$HOME/nix-config" checkout -- flake.lock
}

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
