{config, lib, ...}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.wezterm-path;
in {
  options.dotfiles.wezterm-path = {
    enable = mkEnableOption "wezterm-path";
  };

  config = mkIf cfg.enable {
    environment.systemPath = [
      /Applications/${"Nix User Apps"}/WezTerm.app/Contents/MacOS
    ];
  };
}
