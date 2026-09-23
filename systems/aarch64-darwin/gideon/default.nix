{lib, ...}: {
  dotfiles = {
    nix.enable = true;
    suites.common.enable = true;
  };

  system.stateVersion = 5;
}
