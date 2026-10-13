{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, noctalia, ... }: {
    nixosConfigurations = {
      
      zeus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.isaac = import ./home-manager/home.nix;

            # Use home-manager.extraSpecialArgs to pass custom arguments to ./home.nix
            # Uncomment the next line to make all flake inputs available in home.nix
            home-manager.extraSpecialArgs = {inherit inputs; };
          }
        ];
       };
       aries = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/aries/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.isaac = import ./home-manager/home.nix;

            # Use home-manager.extraSpecialArgs to pass custom arguments to ./home.nix
            # Uncomment the next line to make all flake inputs available in home.nix
            home-manager.extraSpecialArgs = {inherit inputs; };
          }
        ];
      };
    };
  };
}
