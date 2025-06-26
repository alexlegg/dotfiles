{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.alexl;
in {
  options.dotfiles.alexl = {
    enable = mkEnableOption "Control the group of options that make up the 'alexl' user";
  };

  config = mkIf cfg.enable {
    dotfiles = {
      alejandra.enable = true;
      alt-tab-macos.enable = true;
      apps.enable = true;
      defaults.enable = true;
      diff-so-fancy.enable = true;
      fd.enable = true;
      fzf.enable = true;
      git.enable = true;
      lldb-init.enable = true;
      neovim.enable = true;
      p10k-config.enable = true;
      rectangle.enable = true;
      ripgrep.enable = true;
      rustup.enable = true;
      tree.enable = true;
      #vscode.enable = true;
      zsh.enable = true;
      wezterm.enable = true;
    };
  };
}
