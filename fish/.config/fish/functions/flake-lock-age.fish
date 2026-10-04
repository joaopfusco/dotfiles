function flake-lock-age
    git -C $HOME/nix-config log -1 --format='%cd (%cr)' --date=short -- flake.lock
end
