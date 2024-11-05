{ inputs, lib, stdenvNoCC, zsh }: stdenvNoCC.mkDerivation {
  pname = "zsh-title-update";
  version = "local";

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -D ${./zsh-title-update.plugin.zsh} $out/share/zsh-title-update/zsh-title-update.plugin.zsh
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

