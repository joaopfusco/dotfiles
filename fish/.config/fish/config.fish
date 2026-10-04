if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx DOTNET_NOLOGO 1
set -gx NIX_PATH "nixpkgs=flake:nixpkgs"
set -gx NIXPKGS_ALLOW_UNFREE 1
set -gx NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM 1

status is-interactive; or return

if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

fish_add_path --global --move $HOME/.local/bin $HOME/.opencode/bin $HOME/.dotnet/tools

set -g fish_greeting

set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showstashstate 1
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_showcolorhints 1

alias l 'eza -l'
alias ls l
alias la 'eza -la'
alias lt 'eza --tree'
alias cls 'clear && printf '\''\033[3J'\'''
alias ipe 'curl ifconfig.me'
alias brew-upgrade 'brew update && brew upgrade && brew cleanup'
alias dnix-upgrade 'sudo determinate-nixd upgrade'
alias dnix-version 'determinate-nixd version'
alias nix-upgrade 'sudo -i nix upgrade-nix'

command -q direnv; and direnv hook fish | source
