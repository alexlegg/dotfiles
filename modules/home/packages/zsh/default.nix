{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.zsh;
  fzt = pkgs.zsh-fzf-tab;
  powerlevel10k = pkgs.zsh-powerlevel10k;
  zvm = pkgs.zsh-vi-mode;
  ztu = pkgs.dotfiles.zsh-title-update;
in {
  options.dotfiles.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      history = {
        append = false;
        ignoreAllDups = true;
        extended = true;
        size = 1000000000;
        share = false;
      };
      initExtraBeforeCompInit = ''
        source ${powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      initExtra = ''
        # source zsh-vi-mode
        # Initialise now (when sourcing) so we can override some keybings for
        # fzf and fzf-tab.
        ZVM_INIT_MODE=sourcing
        source ${zvm}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

        # vim mode
        bindkey -v

        # source fzf
        # enableZshIntegrations is turned off in fzf so we can order this after
        # the vim mode plugin.
        source <(fzf --zsh)

        # source fzf-tab
        source ${fzt}/share/fzf-tab/fzf-tab.plugin.zsh

        # source zsh-title-update
        source ${ztu}/share/zsh-title-update/zsh-title-update.plugin.zsh

        # Allow comments
        setopt interactivecomments

        # Append commands history immediately
        setopt INC_APPEND_HISTORY
      '';
      shellAliases = {
        less = "less -i";
        ls = "ls --color=auto";
        diff = "diff --color";
      };
    };
  };
}
