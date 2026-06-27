{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.tmux;
in {
  options.dotfiles.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      mouse = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 100000;
      keyMode = "vi";
      terminal = "tmux-256color";
      extraConfig = ''
        # truecolor passthrough
        set -ag terminal-overrides ",*:Tc"

        # renumber windows when one is closed
        set -g renumber-windows on

        # auto-name windows after the current directory
        set -g automatic-rename on
        set -g automatic-rename-format '#{b:pane_current_path}'

        # focus events for vim/neovim autoread
        set -g focus-events on

        # pass extended key sequences (Shift+Enter, etc.) through to apps
        set -g extended-keys on
        set -as terminal-features ",*:extkeys"

        # splits inherit current pane's working directory
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"

        # status bar — Dracula palette, transparent background
        set -g status-style "bg=default fg=#6272a4"
        set -g status-left  "#[fg=#bd93f9,bold] #S "
        set -g status-right "#[fg=#6272a4]#h "
        set -g status-left-length 30
        set -g window-status-format         " #I:#W "
        set -g window-status-current-format "#[bg=#44475a,fg=#f8f8f2,bold] #I:#W "
      '';
    };
  };
}
