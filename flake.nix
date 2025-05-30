{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
  let
    inherit (self) outputs;

    users = {
      tungle = {
        name = "tungle";
        username = "itungle";
        email = "itungle@gmail.com";
        homeDir = "/Users/tungle";
      };
    };

    mkDarwinConfiguration = system: username: hostname:
      darwin.lib.darwinSystem {
        system = "${system}";
        specialArgs = {
          inherit inputs outputs system hostname;
          userConfig = users.${username};
        };
        modules = [
          {
            system.configurationRevision = self.rev or self.dirtyRev or null; 
          }
          ./hosts/${hostname}
          home-manager.darwinModules.home-manager {
            nixpkgs = { config.allowUnfree = true; }; 
            
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./hosts/${hostname}/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs outputs hostname;
              userConfig = users.${username};
              nhModules = "${self}/modules";
            };
          }
        ];
      };

    mkHomeConfiguration = system: username: hostname:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        extraSpecialArgs = {
          inherit inputs outputs hostname;
          userConfig = users.${username};
          nhModules = "${self}/modules";
        };
        modules = [
          ./hosts/${hostname}/home.nix
        ];
      };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#rintung-mac
    darwinConfigurations = {
      "rintung-mac" = mkDarwinConfiguration "aarch64-darwin" "tungle" "rintung-mac";
    };

    homeConfigurations = {
      "rintung-mac" = mkHomeConfiguration "aarch64-darwin" "tungle" "rintung-mac";
    };

  };
}
