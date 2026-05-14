{
  inputs,
  fetchzip,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wezterm";
  version = "WezTerm-macos-20250625-150518-7524d84f";

  src = fetchzip {
    #url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    # Get the nightly instead
    #url = "https://github.com/wez/wezterm/releases/download/nightly/WezTerm-macos-nightly.zip";
    #hash = "sha256-5Ycm1twA1XGHwfaB+cbEsc3CJlcIkT3mwt74UM0xcCc=";
    # Get my fork instead
    url = "https://github.com/alexlegg/wezterm/releases/download/20250625-150518-7524d84f/WezTerm-macos-20250625-150518-7524d84f.zip";
    hash = "sha256-TpX1Ub9g5FQRl07+UO+y4n5NN6Iv4ro2ZzQ/ffRgUzo=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ unzip ];

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
