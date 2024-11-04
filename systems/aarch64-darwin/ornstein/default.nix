{lib, ...}: {
  dotfiles = {
    nix.enable = true;
  };

  system.stateVersion = 5;
}
