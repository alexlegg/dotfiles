{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.pam-reattach;
in {
  options.dotfiles.pam-reattach = {
    enable = mkEnableOption "pam-reattach";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [pam-reattach];
    environment.etc."pam.d/sudo_local".text = ''
      # generated by nix-darwin/dotfiles
      auth  optional  ${pkgs.pam-reattach}/lib/pam/pam_reattach.so  ignore_ssh
      auth  sufficient  pam_tid.so
    '';
  };
}
