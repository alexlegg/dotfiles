{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.suites.common;
in {
  options.dotfiles.suites.common = {
    enable = mkEnableOption "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    dotfiles = {
      pam-reattach.enable = true;
    };
  };
}
