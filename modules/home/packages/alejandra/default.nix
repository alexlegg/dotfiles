{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.alejandra;
in {
  options.dotfiles.alejandra = {
    enable = mkEnableOption "alejandra";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [alejandra];
  };
}
