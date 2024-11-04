#!/bin/zsh
host=$(scutil --get ComputerName | tr 'A-Z' 'a-z')
nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#${host}
