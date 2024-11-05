{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.module;
in {
  options.dotfiles.module = {
    enable = mkEnableOption "module";
  };

  config = mkIf cfg.enable {
  };
}

