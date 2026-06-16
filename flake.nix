{
  description = "oubliette-btw";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    astal = {
    url = "github:aylur/astal";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; # CRITICAL
  };

    ags = {
    url = "github:aylur/ags";
    inputs.nixpkgs.follows = "nixpkgs-unstable"; # CRITICAL
    inputs.astal.follows = "astal";              # Ensures they use the same Astal version
  };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, mangowm, zen-browser, astal, ags, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.oubliette-btw = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; inherit (zen-browser.packages.${system}) zen-browser; };
        modules = [
          ./configuration.nix
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.badmaster67 = import ./home.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { 
            inherit pkgs-unstable inputs; 
            zen-browser = zen-browser.packages.${system}.zen-browser;
            };
          }
        ];
      };
    };
}
