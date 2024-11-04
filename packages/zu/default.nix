{
  inputs,
  lib,
  morlana,
  stdenvNoCC,
  system,
  writeTextFile,
  zsh,
  flake ? "~/.dotfiles",
  flakes ? {},
}: let
  overrides =
    lib.mapAttrsToList
    (n: v: ["--override-input" n v])
    flakes;

  args = [
    "switch"
    "--no-confirm"
    "--flake ${flake}"
    "--attr darwinConfigurations.$(_get_hostname)"
  ] ++ (builtins.map (v: "--extra-build-flags='${v}'") (lib.flatten overrides));
in
  writeTextFile {
    destination = "/bin/zu";
    executable = true;
    meta = {
      platforms = ["aarch64-darwin" "x86_64-darwin"];
    };
    name = "zu";
    text = ''
      #!${zsh}/bin/zsh

      # lowercase hostname
      function _get_hostname() {
        scutil --get ComputerName | tr 'A-Z' 'a-z'
      }

      function _pre_sudo() {
        sudo -v -p "sudo password: "
      }

      echo "🏡 building: $(_get_hostname)"
      _pre_sudo && \
        ${morlana}/bin/morlana \
          ${builtins.concatStringsSep " \\\n    " args}
    '';
  }
