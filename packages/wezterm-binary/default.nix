{
  inputs,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wezterm";
  version = "20241129-152148-4906789a";


  src = fetchzip {
    #url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    # Get the nightly instead
    url = "https://github.com/wez/wezterm/releases/download/nightly/WezTerm-macos-nightly.zip";
    hash = "sha256-4r1NJzCP5J84heaKlIcbSZAlE5ewXNw2ItcT32LGK3U=";
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
