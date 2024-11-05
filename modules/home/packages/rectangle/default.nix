{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.rectangle;
in {
  options.dotfiles.rectangle = {
    enable = mkEnableOption "rectangle";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rectangle
    ];
  };
}

