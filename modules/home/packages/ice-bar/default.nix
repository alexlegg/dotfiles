{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.ice-bar;
in {
  options.dotfiles.ice-bar = {
    enable = mkEnableOption "ice-bar";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ice-bar
    ];
  };
}
