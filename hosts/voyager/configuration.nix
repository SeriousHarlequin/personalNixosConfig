{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  myNixos = {
    nvidia = {
      enable = true;
      hybrid.enable = true;
    };

    gaming = {
      steam.enable = true;
      steam.gamescope.enable = true;
    };

    software = {
      cli-tools.enable = true;
      libreoffice.enable = true;
      virt-manager.enable = true;
    };

    autoUpdate = {
      enable = true;
      dates = "weekly";
    };

    desktopEnvironments.enableList = [ "gnome" "niri" ];

    audio.enable = true;
    display.enable = true;
  };

  networking.hostName = "voyager";

  users.groups.libvirtd.members = [ "fabian" ];

  services.libinput.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    thunderbird
    pavucontrol
  ];

  system.stateVersion = "25.11";
}
