{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.ninja;
in {
  options.dotfiles.ninja = {
    enable = mkEnableOption "ninja";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ninja
    ];
  };
}
