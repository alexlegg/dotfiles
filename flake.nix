{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # nix-darwin contains nix modules for darwin. Everything is based on this.
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Morlana implements utilities nix-darwin in Rust. It has nicer output.
    morlana = {
      url = "github:ryanccn/morlana";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager manages user environment (i.e. dot files).
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall is the library that opinionates the layout of this repo.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixVim configures neovim from inside nix.
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nix-darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
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

      overlays = with inputs; [
        morlana.overlays.default
      ];

      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
      ];

      systems.modules.darwin = with inputs; [
        nixvim.nixDarwinModules.nixvim
      ];

      snowfall = {
        namespace = "dotfiles";
      };

      outputs-builder = channels: {formatter = channels.nixpkgs.alejandra;};
    };
}
