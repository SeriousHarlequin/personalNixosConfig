{config, lib, pkgs, ...}:
{
    imports = 
        [
            ./stylix.nix
            ./nvidia.nix
            ./gaming.nix
            ./locale.nix
            ./networking.nix
            ./libreoffice.nix
            ./updates.nix
        ];
}

