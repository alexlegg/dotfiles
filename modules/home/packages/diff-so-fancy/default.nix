{ config, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.diff-so-fancy;
in {
  options.dotfiles.diff-so-fancy = {
    enable = mkEnableOption "diff-so-fancy";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      diff-so-fancy
    ];
  };
}
