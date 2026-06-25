# homebrew
if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gentoo"
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# keybindings
autoload -U select-word-style
select-word-style bash
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# aliases
alias ll="ls -l"
alias la="ls -la"
alias cls="clear"
alias py="python3"
alias ipe="curl ifconfig.me"
alias ins="echo $IN_NIX_SHELL"
alias nixd-upgrade="sudo determinate-nixd upgrade"
alias nixd-version="determinate-nixd version"
dots() { (cd "$HOME/dotfiles" && stow -t "$HOME" */) }

# nix
export NIXPKGS_ALLOW_UNFREE=1

# dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_NOLOGO=1
export PATH="$HOME/.dotnet/tools:$PATH"

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
