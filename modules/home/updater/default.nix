{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption;
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

    attr = mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Optional flake attribute name (defaults to host/user auto-detection).";
    };

    overrides = mkOption {
      default = {};
      type = with lib.types; attrsOf str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        (dotfiles.zu.override {
          inherit (cfg) flake attr;
          flakes = cfg.overrides;
        })
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        morlana
      ];
  };
}
