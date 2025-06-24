{
  inputs,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wezterm";
  version = "WezTerm-macos-20250622-064717-2b656cb5";


  src = fetchzip {
    #url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    # Get the nightly instead
    url = "https://github.com/wez/wezterm/releases/download/nightly/WezTerm-macos-nightly.zip";
    hash = "sha256-MIFSz10NcvBg/vMSGAjH8Vgt/yrWIW0fqpLCHUpOyVY=";
  };

  installPhase = ''
    runHook preInstall
    APP="$out/Applications/WezTerm.app"
    mkdir -p "$APP"
    cp -r ./WezTerm.app/. "$APP"
    runHook postInstall
  '';

  meta = {
    platforms = [
      "aarch64-darwin"
    ];
    maintainers = [
      inputs.self.lib.maintainers.alexl
    ];
  };
}
