{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
  let
    system = "aarch64-darwin";
    specialArgs =
      inputs;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rintung-mac
    darwinConfigurations."rintung-mac" = nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [ 
        ./modules/system
      ];
    };
  };
}
