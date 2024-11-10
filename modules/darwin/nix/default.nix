{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.nix;
in {
  options.dotfiles.nix = {
    enable = mkEnableOption "nix configuration";
  };

  config = mkIf cfg.enable {
    nix = {
      # pkgs.nixVersions.stable now points to Lix
      # package = pkgs.nixVersions.stable;
      package = pkgs.lix;

      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        trusted-public-keys = [
        ];
        trusted-users = ["root" "alexl"];
        warn-dirty = false;
      };

      registry.nixpkgs.flake = inputs.nixpkgs;
    };

    services.nix-daemon.enable = true;
    # programs.zsh.enable = true;
  };
}
