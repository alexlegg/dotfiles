{
  inputs,
  lib,
  stdenvNoCC,
  zsh,
}:
stdenvNoCC.mkDerivation {
  pname = "";
  version = "local";

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    #substituteInPlace $out/bin/sdk --replace /bin/zsh "${zsh}/bin/zsh"
    runHook postInstall
  '';

  meta = {
    platforms = [
      "aarch64-darwin"
      # "aarch64-linux"
      # "x86_64-linux"
    ];
    maintainers = [
      inputs.self.lib.maintainers.alexl
    ];
  };
}
