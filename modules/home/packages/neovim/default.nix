{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.neovim;
in {
  options.dotfiles.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      enableMan = false;
      vimAlias = true;
      colorschemes.dracula.enable = true;

      autoCmd = [
        # dim inactive window
        {
          event = ["FocusGained"];
          pattern = "*";
          command = "set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow";
        }
        {
          event = ["FocusLost"];
          pattern = "*";
          command = "set winhighlight=Normal:InactiveWindow,NormalNC:InactiveWindow";
        }
      ];

      opts = {
        clipboard = "unnamedplus";
        expandtab = true;
        number = true;
        shiftwidth = 4;
        smartcase = true;
        splitbelow = true;
        splitright = true;
        tabstop = 4;
        winhighlight = "Normal:ActiveWindow,NormalNC:InactiveWindow";
      };

      plugins = {
        nix.enable = true;
      };
    };
  };
}
