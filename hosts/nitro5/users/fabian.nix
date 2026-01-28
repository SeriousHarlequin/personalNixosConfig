{ config, pkgs, inputs, ... }:

{
  home.username = "fabian";
  home.homeDirectory = "/home/fabian";

  home.stateVersion = "25.11"; # Don't change

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  imports = [
    ../../../globalModules/home-manager/default.nix
  ];

  myHome = {
    ghostty.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
    niri.enable = true;
    waybar.enable = true;
    swaylock.enable = true;
    swayidle.enable = true;
    swaync.enable = true;
    fuzzel.enable = true;
  };

}
