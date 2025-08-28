{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.python;
in {
  options.dotfiles.python = {
    enable = mkEnableOption "python";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python313
    ];
  };
}
