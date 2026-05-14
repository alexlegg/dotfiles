{
  inputs,
  lib,
  morlana,
  stdenvNoCC,
  writeTextFile,
  zsh,
  flake ? "~/.dotfiles",
  flakes ? {},
}: let
  overrides =
    lib.mapAttrsToList
    (n: v: ["--override-input" n v])
    flakes;

  args =
    [
      "--flake ${flake}"
      "--attr darwinConfigurations.$(_get_hostname)"
      "--"
      "--accept-flake-config"
      "--allow-unsafe-native-code-during-evaluation"
      "--option narinfo-cache-negative-ttl 0"
    ]
    ++ (lib.flatten overrides);
in
  writeTextFile {
    destination = "/bin/zu";
    executable = true;
    meta = {
      platforms = ["aarch64-darwin" "x86_64-darwin"];
      maintainers = [
        inputs.self.lib.maintainers.matt
      ];
    };
    name = "zu";
    text = ''
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
          ${builtins.concatStringsSep " \\\n    " args} \
          $*
    '';
  }
