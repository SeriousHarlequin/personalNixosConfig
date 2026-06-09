{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./neovim/default.nix
    ./ghostty.nix
    ./zoxide.nix
    ./zsh.nix
    ./window-manager
    ./waybar.nix
    ./fuzzel.nix
    ./wlogout.nix
    ./git.nix
    ./direnv.nix
  ];
}
