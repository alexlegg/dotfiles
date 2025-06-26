#!/bin/zsh
set -eo pipefail

echo "performing bootstrap..."
host=$(scutil --get ComputerName | tr 'A-Z' 'a-z')
sudo rm /etc/nix/nix.conf || true
nix run \
    --accept-flake-config \
    --extra-experimental-features 'nix-command flakes' \
    github:ryanccn/morlana \
    -- \
    switch \
    --no-confirm \
    --flake . \
    --attr darwinConfigurations.$host \
    -- \
    --accept-flake-config \
    --allow-unsafe-native-code-during-evaluation
