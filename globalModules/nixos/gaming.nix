{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.gaming;
in
{
  options.myNixos.gaming = {
    steam.enable = lib.mkEnableOption "Enable Steam";
    steam.gamescope.enable = lib.mkEnableOption "Enable steam deck desktop environment";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
    })

    (lib.mkIf cfg.steam.gamescope.enable {
      boot.kernelPackages = pkgs.linuxPackages; # (this is the default) some amdgpu issues on 6.10
      programs = {
        gamescope = {
          enable = true;
          capSysNice = true;
        };
        steam = {
          enable = true;
          gamescopeSession.enable = true;
        };
      };
      hardware.xone.enable = true; # support for the xbox controller USB dongle
      services.getty.autologinUser = "fabian";
      environment = {
        systemPackages = [ pkgs.mangohud ];
        loginShellInit = ''
          [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
        '';
      };
    })
  ];
}
