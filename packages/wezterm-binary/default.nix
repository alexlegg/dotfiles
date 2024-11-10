{
  inputs,
  fetchzip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wezterm";
  version = "20240203-110809-5046fc22";

  src = fetchzip {
    url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    hash = "sha256-HKUC7T7VJ+3dDtbOoFc/kVUBUGstsAZn+IpD9oRIMXw=";
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
      # "aarch64-linux"
      # "x86_64-linux"
    ];
    maintainers = [
      inputs.self.lib.maintainers.alexl
    ];
  };
}
