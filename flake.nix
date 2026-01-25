{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, stylix, ... } @ inputs: {
  
    # Laptop
    nixosConfigurations.nitro5 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; }; #allows configuration.nix to access inputs
      modules = [
        ./hosts/nitro5/configuration.nix
	    home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fabian = ./hosts/nitro5/users/fabian.nix;
	    }
        stylix.nixosModules.stylix
      ];
    };
    
    # PC
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; }; #allows configuration.nix to access inputs
      modules = [
        ./hosts/pc/configuration.nix
	    home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fabian = ./hosts/pc/users/fabian.nix;
	    }
        stylix.nixosModules.stylix
      ];
    };

  };
}
