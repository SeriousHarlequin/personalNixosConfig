{
  description = "SeriousHarlequin's personal Nixos fleet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, stylix, niri, ... } @ inputs: {
  
    # Laptop
    nixosConfigurations.voyager = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; }; #allows configuration.nix to access inputs
      modules = [
        ./hosts/voyager/configuration.nix
	    home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.fabian = ./hosts/voyager/users/fabian.nix;
	    }
        stylix.nixosModules.stylix
      ];
    };
    
    # PC
    nixosConfigurations.vanguard = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; }; #allows configuration.nix to access inputs
      modules = [
        ./hosts/vanguard/configuration.nix
	    home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.fabian = ./hosts/vanguard/users/fabian.nix;
	    }
        stylix.nixosModules.stylix
      ];
    };

  };
}
