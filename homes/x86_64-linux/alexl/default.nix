{lib, ...}: {
  dotfiles.alexl.enable = true;
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
