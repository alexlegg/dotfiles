{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.p10k-config;
in {
  options.dotfiles.p10k-config = {
    enable = mkEnableOption "powerlevel10 configuration";
  };

  config = mkIf cfg.enable {
    home.file.".p10k.zsh" = {
      source = ./p10k.zsh;
    };
  };
}
