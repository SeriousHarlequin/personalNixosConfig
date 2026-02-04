{ config, lib, inputs, ... }:
{
    programs.niri.settings = {
        outputs = {
            # MAIN: HKC 27" 1440p @ 144Hz
            "DP-2" = {
                mode = {
                    width = 2560;
                    height = 1440;
                    refresh = 143.995;
                };
                position = { x = 0; y = 0; };
            };

            # LEFT: Fujitsu Siemens (Rotated 90°)
            # Note: After rotation, logical width is 1050. 
            # Positioned at x = -1050 to sit flush against the left of DP-2.
            "DP-1" = {
                mode = {
                    width = 1680;
                    height = 1050;
                    refresh = 59.954;
                };
                transform = {
                    rotation = 90;
                    flipped = false;
                };
                position = { x = -1050; y = 0; };
            };

            # ABOVE: PNP 1440p
            # Positioned at y = -1440 to sit directly above DP-2.
            "HDMI-A-1" = {
                mode = {
                    width = 2560;
                    height = 1440;
                    refresh = 59.951;
                };
                position = { x = 0; y = -1440; };
            };
        };
    };
}
