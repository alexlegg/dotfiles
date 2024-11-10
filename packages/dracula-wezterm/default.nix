{
  inputs,
  lib,
  stdenvNoCC,
  zsh,
}:
stdenvNoCC.mkDerivation {
  pname = "dracula-wezterm";
  version = "main";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/dracula/wezterm.git";
    rev = "0db525a46b5242ee15fd4a52f887e172fbde8e51";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp dracula.toml $out/
    runHook postInstall
  '';

  meta = {
    maintainers = [
      inputs.self.lib.maintainers.alexl
    ];
  };
}
