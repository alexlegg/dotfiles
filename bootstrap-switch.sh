#!/bin/zsh
set -eo pipefail

if [[ -z "$SSH_CONNECTION" ]]; then
    # Create a temporary directory to place the SSH agent socket
    echo "starting ykagent..."
    tmpd=$(mktemp -d)
    KEYCHAIN_CERTIFICATES=$(sc_auth identities | grep -Eo '([A-F0-9]{40})' | tr '\n' ';') \
        GIT_SSH_COMMAND="ssh -o PKCS11Provider=/usr/lib/ssh-keychain.dylib" \
        nix run \
            --accept-flake-config \
            --extra-experimental-features 'nix-command flakes' \
            git+ssh://git@sysctl.co.uk/rust/ykagent#ykagent -- -s "$tmpd/sock" &
    ykpid=$!
    cleanup() { kill -9 "$ykpid" ; rm -rf "$tmpd" }
    trap cleanup EXIT
    trap cleanup INT

    echo "waiting for ykagent socket..."
    while [[ ! -e "$tmpd/sock" ]]; do
        sleep 1
    done
fi

echo "performing bootstrap..."
export SSH_AUTH_SOCK="$tmpd/sock"
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
