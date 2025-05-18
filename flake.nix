{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs, ... }:
  let
    inherit (self) outputs;

    users = {
      tungle = {
        name = "tungle";
        username = "itungle";
        email = "itungle@gmail.com";
      };
    };

    mkDarwinConfiguration = username: hostname:
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
          system = "aarch64-darwin";
        };
        modules = [
          {
            system.configurationRevision = self.rev or self.dirtyRev or null; 
          }
          ./hosts/${hostname}
          # home-manager.darwinModules.home-manager
        ];
      };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rintung-mac
    darwinConfigurations = {
      "rintung-mac" = mkDarwinConfiguration "tungle" "rintung-mac";
    };
  };
}
