{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.tea;
in {
  options.dotfiles.tea = {
    enable = mkEnableOption "tea";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [tea];
  };
}
