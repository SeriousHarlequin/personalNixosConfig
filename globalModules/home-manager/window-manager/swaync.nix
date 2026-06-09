{ config, lib, pkgs, ... }:
let
    cfg = config.myHome.swaync;
in
{
    options.myHome.swaync = {
        enable = lib.mkEnableOption "Enable swaync notification daemon";
    };

    config = lib.mkIf cfg.enable {
        services.swaync = {
            enable = true;

            settings = {
                positionX = "right";
                positionY = "top";
                layer = "top";
                control-center-margin-top = 10;
                control-center-margin-bottom = 10;
                control-center-margin-right = 10;
                control-center-width = 380;
                notification-icon-size = 64;
                notification-body-image-height = 100;
                notification-body-image-width = 200;
                timeout = 10;
                notification-window-width = 400;
                
                # Logic for widgets in the side panel
                widgets = [
                    "title"
                    "dnd"
                    "notifications"
                    "mpris"
                ];
            };

            # Structural Styling (Colors provided by Stylix)
            style = ''

                .notification-row {
                    outline: none;
                    margin: 10px;
                    padding: 0;
                }

                .notification {
                    /* Kill the distracting inner border Stylix added */
                    border: none !important;
                    
                    /* Modern floating look */
                    border-radius: 12px;
                    margin: 6px 12px;
                    box-shadow: 0 4px 12px 0 rgba(0,0,0,0.4);
                    padding: 12px;
                }

                /* This targets the actual background box inside the notification */
                .notification-content {
                    background: transparent;
                    padding: 4px;
                }

                /* Clean up the Control Center (the sidebar) as well */
                .control-center {
                    border: none !important;
                    border-radius: 12px;
                    margin: 10px;
                    box-shadow: 0 4px 12px 0 rgba(0,0,0,0.4);
                }

                /* Ensure buttons inside don't get double borders either */
                .notification-action {
                    border: none !important;
                    border-radius: 8px;
                    margin: 5px;
                    padding: 8px;
                }

                .widget-title {
                    font-size: 1.2rem;
                    margin: 10px;
                }

                .widget-dnd {
                    margin: 10px;
                    padding: 5px;
                }

            '';
        };
    };
}
