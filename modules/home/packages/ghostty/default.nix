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

    # macOS's /bin/zsh looks up $TERM once at startup, before /etc/zshenv adds
    # ~/.nix-profile/share/terminfo to TERMINFO_DIRS, and never retries. Over
    # ssh (TERM=xterm-ghostty) that leaves zsh without a terminal definition.
    # ~/.terminfo is searched from the start, so link the entry there too.
    home.file.".terminfo".source = "${pkgs.ghostty-bin.terminfo}/share/terminfo";

    xdg.configFile."ghostty/config".text = ''
      font-family = JetBrains Mono
      font-size = 15

      theme = Dracula

      scrollback-limit = 100000000
      bell-features = no-system, no-audio

      # Always start new windows and tabs in ~ rather than the focused one's cwd.
      # tmux mirrors this with `bind c new-window -c ~`, since super+t below
      # opens a tmux window rather than a ghostty tab.
      working-directory = home
      window-inherit-working-directory = false
      tab-inherit-working-directory = false

      shell-integration = zsh
      shell-integration-features = cursor,sudo,title,ssh-env,ssh-terminfo

      # Forward tab-style shortcuts to tmux instead of using ghostty's native tabs.
      # Each sends the tmux prefix (C-Space = \x00) followed by the action key.
      keybind = super+t=text:\x00c
      keybind = ctrl+tab=text:\x00n
      keybind = ctrl+shift+tab=text:\x00p
    '';
  };
}
