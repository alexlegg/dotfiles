{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
        url = "github:snowfallorg/lib";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

      snowfall = {
        namespace = "dotfiles";
      };
    };
}
