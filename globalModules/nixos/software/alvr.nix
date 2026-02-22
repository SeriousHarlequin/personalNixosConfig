{ config, lib, pkgs, ... }:

let
    cfg = config.myNixos.software.alvr;
in
{
    options.myNixos.software.alvr = {
        enable = lib.mkEnableOption "ALVR VR streaming software";
    };

    config = lib.mkIf cfg.enable {
        # Enable the core ALVR program and open firewall ports (UDP 9943, 9944)
        programs.alvr = {
            enable = true;
            openFirewall = true;
        };
    
        # ALVR requires SteamVR, which is bundled with Steam
        programs.steam.enable = true;
    
        # Adds ALVR dashboard to system packages for easy searching
        environment.systemPackages = [ pkgs.alvr ];
    };
}
