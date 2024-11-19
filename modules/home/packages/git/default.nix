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
        rebase = {
          updateRefs = true;
        };

        # Diff-so-fancy
        core.pager = "diff-so-fancy | less --tabs=4 -RF";
        interactive.diffFilter = "diff-so-fancy --patch";
        color.ui = true;
        color.diff-highlight.oldNormal = "red bold";
        color.diff-highlight.oldHighlight = "red bold 52";
        color.diff-highlight.newNormal = "green bold";
        color.diff-highlight.newHighlight = "green bold 22";
        color.diff.meta = "11";
        color.diff.frag = "magenta bold";
        color.diff.func = "146 bold";
        color.diff.commit = "yellow bold";
        color.diff.old = "red bold";
        color.diff.new = "green bold";
        color.diff.whitespace = "red reverse";
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
