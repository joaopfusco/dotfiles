function flake-lock-revert
    git -C $HOME/nix-config diff --quiet -- flake.lock
    and git -C $HOME/nix-config checkout HEAD~1 -- flake.lock
    or git -C $HOME/nix-config checkout -- flake.lock
end
