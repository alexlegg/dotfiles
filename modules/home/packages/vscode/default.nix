{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.vscode;
in {
  options.dotfiles.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vscode
    ];
  };
}
