{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.updater;
in {
  options.dotfiles.updater = {
    enable = mkOption {
      default = true;
      type = lib.types.bool;
    };

    flake = mkOption {
      default = "~/.dotfiles";
      type = lib.types.str;
    };

    overrides = mkOption {
      default = {};
      type = with lib.types; attrsOf str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (dotfiles.zu.override {
        inherit (cfg) flake;
        flakes = cfg.overrides;
      })
      morlana
    ];
  };
}
