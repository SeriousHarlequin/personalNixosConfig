{config, lib, pkgs, ...}:
{
    imports = 
        [
            ./stylix.nix
            ./nvidia.nix
            ./gaming.nix
            ./locale.nix
            ./networking.nix
            ./software/cli-tools.nix
            ./software/libreoffice.nix
            ./software/alvr.nix
            ./software/virt-manager.nix
            ./updates.nix
            ./desktop-environments.nix
        ];
}

