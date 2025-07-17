{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.git-lfs;
in {
  options.dotfiles.git-lfs = {
    enable = mkEnableOption "git-lfs";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ git-lfs ];
  };
}
