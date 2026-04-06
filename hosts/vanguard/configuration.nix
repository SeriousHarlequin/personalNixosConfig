{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  myNixos = {
    nvidia = {
      enable = true;
      hybrid.enable = false;
    };

    gaming = {
      steam.enable = true;
      steam.gamescope.enable = false;
    };

    software = {
      cli-tools.enable = true;
      libreoffice.enable = true;
      virt-manager.enable = true;
      alvr.enable = true;
    };

    autoUpdate = {
      enable = true;
      dates = "weekly";
    };

    desktopEnvironments.enableList = [ "gnome" "niri" ];

    audio.enable = true;
    display.enable = true;
  };

  networking.hostName = "vanguard";

  users.groups.libvirtd.members = [ "fabian" ];

  services.libinput.enable = false;

  programs.firefox.enable = true;

  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];

  environment.systemPackages = with pkgs; [
    thunderbird
    discord
    pavucontrol
    claude-code
    gutenprint-bin
  ];

  system.stateVersion = "25.11";
}
