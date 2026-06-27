{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.ghostty;
in {
  options.dotfiles.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ghostty-bin
    ];

    xdg.configFile."ghostty/config".text = ''
      font-family = JetBrains Mono
      font-size = 15

      theme = Dracula

      scrollback-limit = 100000000
      audible-bell = false

      shell-integration = zsh
      shell-integration-features = cursor,sudo,title

      # Forward tab-style shortcuts to tmux instead of using ghostty's native tabs.
      # Each sends the tmux prefix (C-Space = \x00) followed by the action key.
      keybind = super+t=text:\x00c
      keybind = ctrl+tab=text:\x00n
      keybind = ctrl+shift+tab=text:\x00p
    '';
  };
}
