{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.fzf;
in {
  options.dotfiles.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      # We'll do this manually in the zsh module to handle the ordering.
      enableZshIntegration = false;
    };
  };
}
