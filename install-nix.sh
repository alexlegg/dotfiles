#!/bin/zsh
./.installer.sh install --extra-conf "trusted-users = root alexl" $*

sudo plutil -insert EnvironmentVariables -dictionary /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo plutil -insert EnvironmentVariables.OBJC_DISABLE_INITIALIZE_FORK_SAFETY -string YES /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
