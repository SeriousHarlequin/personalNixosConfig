{config, lib, inputs, ...}:
{
    programs.niri.settings = {
        outputs = {
            # MAIN: HKC 27" 1440p
            "DP-2" = {
                mode = "2560x1440@143.995"; # Max res and max refresh rate
                position = { x = 0; y = 0; };
            };

            # LEFT: Fujitsu (Rotated 90°)
            # Positioned left: 0 - 1050 (its width when rotated) = -1050
            "DP-1" = {
                mode = "1680x1050@59.954";
                transform = "90"; 
                position = { x = -1050; y = 0; }; 
            };

            # ABOVE: PNP 1440p
            # Positioned above: 0 - 1440 (its height) = -1440
            "HDMI-A-1" = {
                mode = "2560x1440@59.951";
                position = { x = 0; y = -1440; };
          };
      };
    };
}
