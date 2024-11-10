{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.fd;
in {
  options.dotfiles.fd = {
    enable = mkEnableOption "fd";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
    ];
  };
}
