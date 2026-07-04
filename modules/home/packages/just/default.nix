{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.just;
in {
  options.dotfiles.just = {
    enable = mkEnableOption "just";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [just];
  };
}
