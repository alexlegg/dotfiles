{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.ntfy-sh;
in {
  options.dotfiles.ntfy-sh = {
    enable = mkEnableOption "ntfy-sh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ntfy-sh
    ];
  };
}
