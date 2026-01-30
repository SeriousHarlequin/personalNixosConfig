{ config, lib, pkgs, ... }:
let
    cfg = config.myHome.waybar;
    swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
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
                    modules-right = [ "cpu" "memory" "pulseaudio" "network" "battery" "custom/notification" "tray" ];

                    "niri/window" = {
                        format = "{}";
                        max-length = 50;
                    };

                    "clock" = {
                        format = "{:%H:%M | %a, %d %b}";
                        tooltip-format = "<tt><small>{calendar}</small></tt>";
                    };

                    "battery" = {
                        states = {
                            warning = 30;
                            critical = 15;
                        };
                        format = "{icon} {capacity}%";
                        format-charging = " {capacity}%";
                        format-plugged = " {capacity}%";
                        format-alt = "{icon} {time}";
                        format-icons = [ "" "" "" "" "" ];
                    };

                    "custom/notification" = {
                        tooltip = false;
                        format = "{icon}";
                        format-icons = {
                            notification = "<span foreground='red'><sup></sup></span>";
                            none = "";
                            dnd-notification = "<span foreground='red'><sup></sup></span>";
                            dnd-none = "";
                            inhibited = "";
                        };
                        return-type = "json";
                        exec-if = "which swaync-client";
                        exec = "${swaync-client} -swb";
                        on-click = "${swaync-client} -t -sw";
                        on-click-right = "${swaync-client} -d -sw";
                        escape = true;
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
                        on-click = "${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
                    };

                    "tray" = {
                        spacing = 10;
                    };
                };
            };

            style = ''
                * {
                    font-family: "JetBrainsMono Nerd Font";
                    font-size: 14px;
                    border: none;
                    border-radius: 0;
                }

                window#waybar {
                    background-color: rgba(0, 0, 0, 0); /* Transparent bar background */
                }

                #clock, 
                #cpu, 
                #memory, 
                #pulseaudio, 
                #network, 
                #battery, 
                #custom-notification, 
                #tray {
                    padding: 0 10px;
                    margin: 0 4px;
                }

                #custom-notification {
                    font-size: 16px;
                }
            '';
        };
    };
}
