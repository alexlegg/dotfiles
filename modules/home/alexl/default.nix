{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault mkMerge;
  cfg = config.dotfiles.alexl;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  options.dotfiles.alexl = {
    enable = mkEnableOption "Control the group of options that make up the 'alexl' user";
  };

  config = mkIf cfg.enable {
    dotfiles = mkMerge [
      # Cross-platform core (Linux servers & macOS)
      {
        alejandra.enable = mkDefault true;
        fd.enable = mkDefault true;
        fzf.enable = mkDefault true;
        ghostty.enable = mkDefault true;
        neovim.enable = mkDefault true;
        p10k-config.enable = mkDefault true;
        ripgrep.enable = mkDefault true;
        tmux.enable = mkDefault true;
        zsh.enable = mkDefault true;
      }

      # macOS desktop & personal dev tools
      (mkIf isDarwin {
        alt-tab-macos.enable = mkDefault true;
        apps.enable = mkDefault true;
        claude-code.enable = mkDefault true;
        defaults.enable = mkDefault true;
        diff-so-fancy.enable = mkDefault true;
        git.enable = mkDefault true;
        git-lfs.enable = mkDefault true;
        just.enable = mkDefault true;
        lldb-init.enable = mkDefault true;
        ninja.enable = mkDefault true;
        #ntfy-sh.enable = mkDefault true;
        #python.enable = mkDefault true;
        rectangle.enable = mkDefault true;
        rustup.enable = mkDefault true;
        tea.enable = mkDefault true;
        tio.enable = mkDefault true;
        tree.enable = mkDefault true;
        uv.enable = mkDefault true;
        vscode.enable = mkDefault true;
        wezterm.enable = mkDefault true;
        yq.enable = mkDefault true;
      })
    ];
  };
}
