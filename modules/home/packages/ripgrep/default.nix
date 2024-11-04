{ config, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.ripgrep;
in {
  options.dotfiles.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
    ];
  };
}
