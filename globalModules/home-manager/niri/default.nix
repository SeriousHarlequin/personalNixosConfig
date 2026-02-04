{ config, lib, pkgs, inputs, ...}:
let
    cfg = config.myHome.niri;
in
{
    imports = [ inputs.niri.homeModules.niri ];


    options.myHome.niri = {
        enable = lib.mkEnableOption "Enable Niri styling for user";
    };

    config = lib.mkIf cfg.enable {
        programs.niri.enable = true;

        programs.niri.package = pkgs.niri;

        programs.niri.settings = {
            # 1. Inputs (Mouse/Keyboard/Touchpad)
            input = {
                keyboard.xkb.layout = "de";
                touchpad = {
                    tap = true;
                    dwt = true;
                };
            };

            spawn-at-startup = [
                { command = [ "${pkgs.swaybg}/bin/swaybg" "-i" "${config.stylix.image}" "-m" "fill" ]; }
            ];

            # 2. Layout & Styling
            # Stylix will automatically inject colors into 'focus-ring' 
            # and 'border' unless you override them here.
            layout = {
                gaps = 12;
                center-focused-column = "never";

                preset-column-widths = [
                    { proportion = 1.0 / 3.0; }
                    { proportion = 1.0 / 2.0; }
                    { proportion = 2.0 / 3.0; }
                ];
                default-column-width = { proportion = 1.0 / 2.0; };
            };

            # 3. Keybinds
            binds = with config.lib.niri.actions; {

                # Essentials
                "Mod+Shift+7".action = show-hotkey-overlay;
                "Mod+T".action = spawn "ghostty";
                "Mod+D".action = spawn "fuzzel";
                "Mod+W".action = spawn "firefox";
                "Mod+Q".action = close-window;
                "Mod+E".action = spawn "nautilus";
                "Mod+N".action = spawn "networkmanager_dmenu";
                "Mod+M".action.spawn = [ "ghostty" "-e" "btop" ];
                "Mod+S".action = spawn "pavucontrol";
                "Mod+BackSpace".action.spawn = [ "wlogout" "-b" "2" ];

                "Mod+Shift+E".action = quit;
                "Mod+Shift+P".action = power-off-monitors;
                "Mod+Escape".action = spawn "swaylock";

                # Window Navigation
                "Mod+Left".action = focus-column-left;
                "Mod+Right".action = focus-column-right;
                "Mod+Up".action = focus-window-up;
                "Mod+Down".action = focus-window-down;

                "Mod+H".action = focus-column-left;
                "Mod+L".action = focus-column-right;
                "Mod+K".action = focus-window-up;
                "Mod+J".action = focus-window-down;

                "Mod+Alt+Left".action = focus-monitor-left;
                "Mod+Alt+Right".action = focus-monitor-right;
                "Mod+Alt+Up".action = focus-monitor-up;
                "Mod+Alt+Down".action = focus-monitor-down;

                "Mod+Alt+H".action = focus-monitor-left;
                "Mod+Alt+L".action = focus-monitor-right;
                "Mod+Alt+K".action = focus-monitor-up;
                "Mod+Alt+J".action = focus-monitor-down;

                # Window Manipulation
                "Mod+Shift+Left".action = move-column-left;
                "Mod+Shift+Right".action = move-column-right;

                "Mod+Shift+H".action = move-column-left;
                "Mod+Shift+L".action = move-column-right;

                "Mod+Alt+Shift+Left".action = move-column-to-monitor-left;
                "Mod+Alt+Shift+Right".action = move-column-to-monitor-right;
                "Mod+Alt+Shift+Up".action = move-column-to-monitor-up;
                "Mod+Alt+Shift+Down".action = move-column-to-monitor-down;

                "Mod+Alt+Shift+H".action = move-column-to-monitor-left;
                "Mod+Alt+Shift+L".action = move-column-to-monitor-right;
                "Mod+Alt+Shift+K".action = move-column-to-monitor-up;
                "Mod+Alt+Shift+J".action = move-column-to-monitor-down;

                "Mod+R".action = switch-preset-column-width;
                "Mod+F".action = maximize-column;
                "Mod+Shift+F".action = fullscreen-window;
                "Mod+C".action = center-column;

                "Mod+Minus".action = set-column-width "-10%";
                "Mod+Plus".action = set-column-width "+10%";
                "Mod+Shift+Minus".action = set-window-height "-10%";
                "Mod+Shift+Plus".action = set-window-height "+10%";

                "Mod+8".action = consume-or-expel-window-left;
                "Mod+9".action = consume-or-expel-window-right;

                "Mod+V".action = toggle-window-floating;
                "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
                
                #Workspaces
                "Mod+Page_Up".action = focus-workspace-up;
                "Mod+Page_Down".action = focus-workspace-down;
                "Mod+U".action = focus-workspace-up;
                "Mod+I".action = focus-workspace-down;

                "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
                "Mod+Shift+Page_Down".action = move-column-to-workspace-down;
                "Mod+Shift+U".action = move-column-to-workspace-up;
                "Mod+Shift+I".action = move-column-to-workspace-down;
                
                "Mod+O".action = toggle-overview;

                # Screenshot
                "Print".action.screenshot = { };
                #"Print+Shift".action.screenshot-screen = { };
                #"Print+Alt".action.screenshot-window = { };


            };

            # 4. Window Rules
            window-rules = [
                {
                    geometry-corner-radius = {
                        bottom-left = 12.0;
                        bottom-right = 12.0;
                        top-left = 12.0;
                        top-right = 12.0;
                    };
                    clip-to-geometry = true;
                    #matches = [{ app-id = "firefox"; }];
                    #open-maximized = true;
                }

                # Pavucontrol
                {
                    matches = [{ app-id = "org.pulseaudio.pavucontrol"; }];
                    open-floating = true;
                    
                    # Optional: Set a specific size so it's not a tiny square
                    default-column-width.proportion = 0.5;
                    default-window-height.proportion = 0.4;
                }

                # Nautilus
                {
                    matches = [{ app-id = "org.gnome.Nautilus";}];
                    open-floating = true;

                    default-column-width.proportion = 0.5;
                    default-window-height.proportion = 0.6;
                }
            ];
        };
    };
}
