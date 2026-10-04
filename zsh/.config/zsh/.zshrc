HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

bindkey -e
autoload -U select-word-style up-line-or-beginning-search down-line-or-beginning-search
select-word-style bash
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^H' backward-kill-word

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{5}(%F{2}%b%F{5})%f '
precmd() { vcs_info }
setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m %F{blue}%~ ${vcs_info_msg_0_}%F{blue}$%b%f '

alias l='eza -l'
alias ls=l
alias la='eza -la'
alias lt='eza --tree'
alias cls='clear && printf '\''\033[3J'\'''
alias ipe='curl ifconfig.me'

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

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
