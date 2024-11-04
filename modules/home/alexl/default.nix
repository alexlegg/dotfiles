{ config, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.alexl;
in {
  options.dotfiles.alexl = {
    enable = mkEnableOption "Control the group of options that make up the 'alexl' user";
  };

  config = mkIf cfg.enable {
    dotfiles = {
      diff-so-fancy.enable = true;
      fd.enable = true;
      git.enable = true;
      ripgrep.enable = true;
      tree.enable = true;
      zsh.enable = true;
    };
  };
}
