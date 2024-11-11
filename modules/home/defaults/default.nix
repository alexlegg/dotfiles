{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dotfiles.defaults;
in {
  options.dotfiles.defaults = {
    enable = mkEnableOption "defaults";
  };

  config = mkIf cfg.enable {
    targets.darwin.defaults = {
      NSGlobalDomain = {
        # turn off all the auto corrects
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSTableViewDefaultSizeMode = 1;

        # Scroll in the correct direction
        "com.apple.swipescrolldirection" = false;
        # Disable force click
        "com.apple.trackpad.forceClick" = false;
        # Tap to click
        "com.apple.mouse.tapBehavior" = 1;

        # Dark mode
        AppleInterfaceStyle = "Dark";
      };
      "com.apple.Finder" = {
        # List view as default
        FXPreferredViewStyle = "Nlsv";
      };
      "com.apple.screencapture" = {
        target = "clipboard";
      };
      dock = {
        persistent-apps = [
          "/Applications/Safari.app"
          "/Applications/Mail.app"
          "/Applications/Calendar.app"
          # "/Applications/Google Chrome.app"
          # Obsidian here?
          "/Applications/Nix User Apps/WezTerm.app"
          "/Applications/System Settings.app"
        ];
      };
    };
  };
}
