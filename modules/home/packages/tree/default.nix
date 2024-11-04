{ config, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.tree;
in {
  options.dotfiles.tree = {
    enable = mkEnableOption "tree";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
