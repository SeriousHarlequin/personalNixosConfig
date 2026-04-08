{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    extraConfig.credential.credentialStore = "secretservice";
  };
}
