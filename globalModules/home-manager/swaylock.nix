{ config, pkgs, lib, ... }:

let
    cfg = config.myHome.swaylock;
in
{
    options.myHome.swaylock = {
        enable = lib.mkEnableOption "Custom swaylock configuration";
    };

    config = lib.mkIf cfg.enable {
        programs.swaylock = {
            enable = true;
            package = pkgs.swaylock-effects;
            settings = {
                # Visuals
                #color = "11111b";
                font = "JetBrainsMono Nerd Font";
                show-failed-attempts = true;
                
                # Indicator Geometry
                indicator-radius = 100;
                indicator-thickness = 10;
                line-uses-ring = true;
                
                # Catppuccin-style Palette
                #ring-color = "89b4fa";      # Blue
                #key-hl-color = "f5c2e7";    # Pink
                #bs-hl-color = "f38ba8";     # Red
                #text-color = "cdd6f4";      # Text
                
                # Swaylock-effects Specific
                screenshots = true;
                clock = true;
                indicator = true;
                effect-blur = "7x5";
                effect-vignette = "0.5:0.5";
                
                # Behavior
                ignore-empty-password = true;
            };
        };
    };
}
