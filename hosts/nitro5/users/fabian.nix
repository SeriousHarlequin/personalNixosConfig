{ config, pkgs, ... }:

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
  };
}
