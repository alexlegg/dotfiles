{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.git;
in {
  options.dotfiles.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName = "Alex Legg";
      userEmail = "alex@legg.info";

      aliases = {
        "currtag" = "describe --abbrev=0";
        "ol" = "log --pretty=format:'%C(yellow)%h %Cblue%an%Cgreen%d %Creset%s' --date=short";
      };

      extraConfig = {
        core = {
          # https://www.git-tower.com/blog/make-git-rebase-safe-on-osx/#
          trustctime = true;
        };
        init.defaultBranch = "main";
      };

      ignores = [
        "*.swp"
        ".vscode"
        "*.code-workspace"
        "build/"
        ".DS_Store"
      ];
    };
  };
}
