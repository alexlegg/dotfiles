{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.rustup;
in {
  options.dotfiles.rustup = {
    enable = mkEnableOption "rustup";
  };

  config =
    mkIf cfg.enable {
      home.packages = with pkgs; [
        rustup
      ];
    };
}
