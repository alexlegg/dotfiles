{
  inputs,
  lib,
  morlana ? null,
  stdenvNoCC,
  writeTextFile,
  zsh,
  flake ? "~/.dotfiles",
  attr ? null,
  flakes ? {},
}: let
  isDarwin = stdenvNoCC.hostPlatform.isDarwin;
  home-manager = inputs.home-manager.packages.${stdenvNoCC.hostPlatform.system}.home-manager;

  overrides =
    lib.mapAttrsToList
    (n: v: ["--override-input" n v])
    flakes;

  darwinArgs =
    [
      "--flake ${flake}"
      "--attr darwinConfigurations.$(_get_hostname)"
      "--"
      "--accept-flake-config"
      "--allow-unsafe-native-code-during-evaluation"
      "--option narinfo-cache-negative-ttl 0"
    ]
    ++ (lib.flatten overrides);

  linuxArgs =
    [
      ''--flake "$target"''
      "--option narinfo-cache-negative-ttl 0"
    ]
    ++ (lib.mapAttrsToList
      (n: v: "--override-input ${lib.escapeShellArg n} ${lib.escapeShellArg v}")
      flakes);
in
  writeTextFile {
    destination = "/bin/zu";
    executable = true;
    meta = {
      platforms = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      maintainers = [
        inputs.self.lib.maintainers.alexl
      ];
    };
    name = "zu";
    text =
      if isDarwin
      then ''
        #!${zsh}/bin/zsh
        action=''${1:-"switch"}
        confirm=
        if (( $# > 0 )); then
          shift
        fi

        # lowercase hostname
        function _get_hostname() {
          scutil --get ComputerName | tr 'A-Z' 'a-z'
        }

        function _pre_sudo() {
          [[ "$action" == "switch" ]] && sudo -v -p "sudo password: "
          true
        }

        if [[ "$action" == "switch" ]]; then
          confirm="--no-confirm"
        fi

        echo "🏡 ''${action}ing: $(_get_hostname)"
        _pre_sudo && \
          ${morlana}/bin/morlana \
            $action $confirm \
            ${builtins.concatStringsSep " \\\n    " darwinArgs} \
            $*
      ''
      else ''
        #!${zsh}/bin/zsh
        set -euo pipefail

        action=''${1:-"switch"}
        if (( $# > 0 )); then
          shift
        fi

        flake_ref=${lib.escapeShellArg flake}
        flake_ref="''${flake_ref/#\~/$HOME}"
        ${
          if attr != null
          then ''target="''${flake_ref}#${attr}"''
          else ''target="$flake_ref"''
        }

        echo "🏡 ''${action}ing: $target"
        exec ${home-manager}/bin/home-manager \
          "$action" \
          ${lib.concatStringsSep " \\\n          " linuxArgs} \
          "$@"
      '';
  }
