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
    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, home-manager, stylix, niri, claude-code, ... } @ inputs:
  let
    mkHost = { host, users ? [ "fabian" ] }: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./globalModules/nixos/default.nix
        ./hosts/${host}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users = builtins.listToAttrs (map (user: {
            name = user;
            value = ./hosts/${host}/users/${user}.nix;
          }) users);
        }
        stylix.nixosModules.stylix
      ];
    };
  in {

    nixosConfigurations.voyager = mkHost { host = "voyager"; };  # Laptop
    nixosConfigurations.vanguard = mkHost { host = "vanguard"; }; # PC

  };
}
