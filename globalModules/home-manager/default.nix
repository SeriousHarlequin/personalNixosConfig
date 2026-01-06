{ config, lib, pkgs, ... }:
{
  imports = [
    ./neovim/default.nix
    ./ghostty.nix
    ./zoxide.nix
  ];
}
