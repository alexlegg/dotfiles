{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.tio;
in {
  options.dotfiles.tio = {
    enable = mkEnableOption "tio";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [tio];
  };
}
