{ config, lib, pkgs, ... }:
let
    cfg = config.myHome.waybar;
in
{
    options.myHome.waybar = {
        enable = lib.mkEnableOption "Enables Waybar config";
    };

    config = lib.mkIf cfg.enable {
        programs.waybar = {
            enable = true;

            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 34;
                    
                    modules-left = [ "niri/window" ];
                    modules-center = [ "clock" ];
                    modules-right = [ "cpu" "memory" "pulseaudio" "network" "tray" ];

                    "niri/window" = {
                        format = "{}";
                        max-length = 50;
                    };

                    "clock" = {
                        format = "{:%H:%M | %a, %d %b}";
                        tooltip-format = "<tt><small>{calendar}</small></tt>";
                    };

                    "cpu" = {
                        format = "  {usage}%";
                        interval = 10;
                    };

                    "memory" = {
                        format = "  {}%";
                        interval = 10;
                    };

                    "pulseaudio" = {
                        format = "{icon} {volume}%";
                        format-muted = "󰝟 ";
                        format-icons = {
                            default = [ "" "" "" ];
                        };
                        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
                    };

                    "network" = {
                        format-wifi = "  {essid}";
                        format-ethernet = "󰈀  {ifname}";
                        format-disconnected = "⚠ Disconnected";
                    };

                    "tray" = {
                        spacing = 10;
                    };
                };
            };

            # Styling the bar with CSS
            style = ''
                * {
                    font-family: "JetBrainsMono Nerd Font";
                    font-size: 14px;
                    border: none;
                    border-radius: 0;
                }

                window#waybar {
                }

                #clock, #cpu, #memory, #pulseaudio, #network, #tray {
                    padding: 0 10px;
                    margin: 0 4px;
                }
            '';
        };
    };
}
