{
  inputs,
  fetchzip,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wezterm";
  version = "WezTerm-macos-20250625-150518-7524d84f";

  #src = fetchzip {
    #url = "https://github.com/wez/wezterm/releases/download/${version}/WezTerm-macos-${version}.zip";
    # Get the nightly instead
    #url = "https://github.com/wez/wezterm/releases/download/nightly/WezTerm-macos-nightly.zip";
    #hash = "sha256-5Ycm1twA1XGHwfaB+cbEsc3CJlcIkT3mwt74UM0xcCc=";
    # Get my fork instead
    # This doesn't work. I don't know why.
    #url = "https://github.com/alexlegg/wezterm/releases/download/20250625-150518-7524d84f/WezTerm-macos-20250625-150518-7524d84f.zip";
    #hash = "sha256-KOALlhYkRrpMQHk2LLuwGP0SZv2Na9Uwz0mcPCojaSA=";
  #};

  # Hack
  src = /Users/alexl/src/wezterm/WezTerm-macos-20250625-150518-7524d84f.zip;
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
