function flake-lock-push
    git -C $HOME/nix-config add flake.lock
    and git -C $HOME/nix-config commit -m 'chore: update flake.lock'
    and git -C $HOME/nix-config push
end
