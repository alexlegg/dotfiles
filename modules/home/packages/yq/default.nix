{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.yq;
in {
  options.dotfiles.yq= {
    enable = mkEnableOption "yq";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ yq ];
  };
}
