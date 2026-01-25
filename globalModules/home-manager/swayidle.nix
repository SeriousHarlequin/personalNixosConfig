{ config, pkgs, lib, ... }:
let
    cfg = config.myHome.swayidle;
    # Path to the swaylock binary to ensure it's called correctly
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
    niri = "${pkgs.niri}/bin/niri";
in
{
    options.myHome.swayidle = {
        enable = lib.mkEnableOption "Custom swayidle configuration";
    };

    config = lib.mkIf cfg.enable {
        services.swayidle = {
            enable = true;
            timeouts = [
                # 1. Lock screen after 5 minutes (300 seconds)
                {
                    timeout = 600;
                    command = "${swaylock}";
                }
                # 2. Turn off monitors after 10 minutes (600 seconds)
                {
                    timeout = 900;
                    command = "${niri} msg action power-off-monitors";
                }
            ];
            
            # Events that trigger regardless of timer
            events = [
                # Lock before the system goes to sleep (suspend/hibernate)
                {
                    event = "before-sleep";
                    command = "${swaylock}";
                }
                # Ensure monitors are ready when coming back from lock
                {
                    event = "lock";
                    command = "${swaylock}";
                }
            ];
        };

        # prohibit events when audio is playing
        systemd.user.services.sway-audio-idle-inhibit = {
            Unit = {
                Description = "Inhibit swayidle when audio is playing";
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
            };

            Service = {
                ExecStart = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
                Restart = "always";
            };

            Install = {
                WantedBy = [ "graphical-session.target" ];
            };
        };
    };
}
