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

        # focus events for vim/neovim autoread
        set -g focus-events on

        # splits inherit current pane's working directory
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded"
      '';
    };
  };
}
