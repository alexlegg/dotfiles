{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.uv;
in {
  options.dotfiles.uv = {
    enable = mkEnableOption "uv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      uv
    ];
  };
}
