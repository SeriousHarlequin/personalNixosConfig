{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.printing;
in
{
  options.myNixos.printing.enable = lib.mkEnableOption "Enable CUPS printing services";

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
