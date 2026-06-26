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

      macos-titlebar-style = tabs

      shell-integration = zsh
      shell-integration-features = cursor,sudo,title

      # Cmd-T opens a new tab in the home directory (parity with wezterm)
      keybind = super+t=new_tab_with_default_command

      # Move tabs left/right (parity with wezterm Ctrl+Shift+,/.)
      keybind = ctrl+shift+comma=move_tab:-1
      keybind = ctrl+shift+period=move_tab:1
    '';
  };
}
