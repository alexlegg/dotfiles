{ config, inputs, lib, pkgs, ... }: let 
  inherit (lib) mkIf mkEnableOption mkOption;
  apps = pkgs.buildEnv {
    name = "home-manager-apps";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
  cfg = config.dotfiles.apps;
  dag = inputs.home-manager.lib.hm.dag;
in {
  options.dotfiles.apps = {
    enable = mkEnableOption "Links apps into ~/Applications using aliases";

    loginItems = mkOption {
      default = [];
      description = "Nix-installed Applications added as login items.";
      type = lib.types.listOf lib.types.str;
    };

    restartCommands = mkOption {
      default = {};
      description = "Commands to run when replacing an app with the given key.";
      type = lib.types.attrsOf lib.types.str;
    };
  };

  config = mkIf cfg.enable {
    # disable the default app linking directory
    home.file."Applications/Home Manager Apps".enable = false;

    # TODO: need to remove stale apps
    home.activation.apps = let 
      cmds = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: ''
        if [[ "$base" == "${n}" ]]; then
          echo "restarting: ${n}"
          ${v}
        fi
      '') cfg.restartCommands);
    in dag.entryAfter ["writeBoundary" "linkGeneration" "setDarwinDefaults"] ''
      appDir="/Applications/Nix User Apps"
      mkdir -p "$appDir"
      for app in "$appDir"/*; do
        base=$(basename "$app")
        target="${apps}/Applications/$base"
        if [ ! -d "$target" ]; then
          echo "removing app: $base"
          $DRY_RUN_CMD rm -rf "$app"
        fi
      done
      for app in ${apps}/Applications/*; do
        app=$(readlink "$app")
        base=$(basename "$app")
        target="$appDir/$base"

        if [ -e "$target" ]; then
          oldsource=$(/usr/bin/xattr -p nix.apps.source "$target" 2>/dev/null || echo "")
          if [[ "$oldsource" == "$app" ]]; then
            continue;
          fi
          $DRY_RUN_CMD rm -rf "$target"
        fi

        echo "updating app: $base"
        $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -a "$app/." "$target"
        # $DRY_RUN_CMD /usr/bin/osascript \
        #   -e 'tell app "Finder"' \
        #   -e "make new alias file at POSIX file \"$appDir\" to POSIX file \"$app\"" \
        #   -e "set name of result to \"''${app##*/}\"" \
        #   -e 'end tell'
        $DRY_RUN_CMD chmod -R u+w "$target"
        $DRY_RUN_CMD /usr/bin/xattr -w nix.apps.source "$app" "$target"
        ${cmds}
      done
    '';

    #home.activation.loginItems = dag.entryAfter ["apps" "linkGeneration" "setDarwinDefaults"] ''
    #  ${pkgs.dotfiles.nix-loginitems}/bin/nix-loginitems \
    #    ${lib.concatStringsSep " " (builtins.map (x: ''"${x}"'') cfg.loginItems)}
    #'';
  };
}
