{ config, lib, pkgs, ... }:
{
  imports = [
    ./neovim/default.nix
    ./ghostty.nix
    ./zoxide.nix
    ./zsh.nix
    ./niri/default.nix
  ];
}
