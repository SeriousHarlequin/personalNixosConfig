{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./neovim/default.nix
    ./ghostty.nix
    ./zoxide.nix
    ./zsh.nix
    ./niri/default.nix
    ./waybar.nix
    ./swaylock.nix
    ./swayidle.nix
    ./swaync.nix
    ./fuzzel.nix
    ./wlogout.nix
  ];
}
