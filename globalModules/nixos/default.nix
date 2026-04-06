{config, lib, pkgs, ...}:
{
    imports = 
        [
            ./common.nix
            ./stylix.nix
            ./nvidia.nix
            ./gaming.nix
            ./locale.nix
            ./networking.nix
            ./audio.nix
            ./display.nix
            ./software/cli-tools.nix
            ./software/libreoffice.nix
            ./software/alvr.nix
            ./software/virt-manager.nix
            ./updates.nix
            ./desktop-environments.nix
        ];
}

