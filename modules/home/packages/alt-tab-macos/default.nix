{ config, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.alt-tab-macos;
in {
  options.dotfiles.alt-tab-macos = {
    enable = mkEnableOption "alt-tab-macos";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotfiles.alt-tab-macos
    ];
  };
}
