{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.claude-code;
in {
  options.dotfiles.claude-code = {
    enable = mkEnableOption "claude-code";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [claude-code];
  };
}
