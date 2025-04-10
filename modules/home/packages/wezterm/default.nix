{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.wezterm;
  dracula-wezterm = pkgs.dotfiles.dracula-wezterm;
in {
  options.dotfiles.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotfiles.wezterm-binary
      dotfiles.dracula-wezterm
    ];

    xdg.configFile."wezterm/colors/dracula.toml" = {
      source = "${dracula-wezterm}/dracula.toml";
    };

    xdg.configFile."wezterm/wezterm.lua".text = ''
      -- Pull in the wezterm API
      local wezterm = require 'wezterm'

      -- This will hold the configuration.
      local config = wezterm.config_builder()

      -- Disable bell
      config.audible_bell = "Disabled"

      -- Color scheme
      config.color_scheme = 'Dracula (Official)'

      -- Dracula theme (draculatheme.com)
      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = true
      config.window_decorations = "RESIZE"

      -- Font
      config.font = wezterm.font 'JetBrains Mono'
      config.font_size = 15

      -- Scrollback
      config.scrollback_lines = 100000

      local act = wezterm.action
      config.keys = {
        -- Scroll to last prompt
        { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
        { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },

        -- Override CMD+t to always start new tabs in the home directory.
        { key = 't', mods = 'SUPER', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },

        { key = 'F', mods = 'SUPER|SHIFT', action = act.Multiple({
          act.ScrollToPrompt(-1),
          act.Search({CaseSensitiveString=""}),
        })},

        -- Move tabs
        { key = ',', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
        { key = '.', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
      }

      local search_mode = nil
      if wezterm.gui then
          search_mode = wezterm.gui.default_key_tables().search_mode

          -- Override escape to clear the search pattern as well as close search.
          table.insert(search_mode,
              {
                  key = 'Escape',
                  mods = 'NONE',
                  action = act.Multiple({
                      act.CopyMode('ClearPattern'),
                      act.CopyMode('Close'),
                  })
              }
          )
      end

      config.key_tables = {
          search_mode = search_mode,
      }

      -- SSH domains

      config.ssh_domains = {
          {
              name = "smough",
              remote_address = "smough",
              username = "alexl",
              remote_wezterm_path = '/Applications/Nix\\ User\\ Apps/WezTerm.app/Contents/MacOS/wezterm',
          },
          {
              name = "nito",
              remote_address = "nito",
              username = "alexl",
              remote_wezterm_path = '/Applications/Nix\\ User\\ Apps/WezTerm.app/Contents/MacOS/wezterm',
          },
      }

      -- and finally, return the configuration to wezterm
      return config
    '';

    programs.zsh.initExtra = ''
      path=('/Applications/Nix User Apps/WezTerm.app/Contents/MacOS' $path)
      export PATH
    '';
  };
}
