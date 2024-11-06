{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.dotfiles.lldb-init;
in {
  options.dotfiles.lldb-init = {
    enable = mkEnableOption "lldb-init";
    extraConfig = mkOption {
      default = "";
      type = lib.types.lines;
      description = "Extra lines to add to .lldbinit";
    };
  };

  config = mkIf cfg.enable {
    home.file.".lldbinit".text = lib.concatStringsSep "\n" [
      ''
        settings set target.load-script-from-symbol-file true
      ''
      cfg.extraConfig
    ];
  };
}
