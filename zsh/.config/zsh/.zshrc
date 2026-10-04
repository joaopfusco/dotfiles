# Source the first existing file, since paths differ between different package managers
source_first() {
  local f
  for f in "$@"; do
    [[ -r $f ]] && { source "$f"; return }
  done
}

# History shared across sessions, skipping duplicates and space-prefixed commands
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Tab completion with an arrow-navigable menu and case-insensitive matching
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Emacs keys; up/down search history by the typed prefix; Ctrl+H deletes a word
bindkey -e
autoload -U select-word-style up-line-or-beginning-search down-line-or-beginning-search
select-word-style bash
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^H' backward-kill-word

# Git status in the prompt via git's own git-prompt.sh
source_first \
  "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh" \
  /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh \
  /usr/lib/git-core/git-sh-prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_SHOWCOLORHINTS=1

# Set PROMPT once instead of in precmd so venv and others can prepend to it
setopt PROMPT_SUBST
PROMPT='%B%F{green}%n@%m %F{blue}%~%f%b$(__git_ps1 " (%s)") %B%F{blue}$%f%b '

alias l='eza -l'
alias ls=l
alias la='eza -la'
alias lt='eza --tree'
alias cls='clear && printf '\''\033[3J'\'''
alias ipe='curl ifconfig.me'

# Plugins from Homebrew (macOS) or apt (Linux); syntax highlighting must load last
source_first \
  "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_first \
  "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load and unload .envrc files when changing directories
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
