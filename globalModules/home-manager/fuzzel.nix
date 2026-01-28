{ config, lib, pkgs, ... }:

let
    cfg = config.myHome.fuzzel;
in
{
    options.myHome.fuzzel = {
        enable = lib.mkEnableOption "Custom Fuzzel configuration";
    };

    config = lib.mkIf cfg.enable {
        programs.fuzzel = {
            enable = true;
            settings = {
                main = {
                    #font = "JetBrainsMono Nerd Font:size=12";
                    terminal = "${pkgs.ghostty}/bin/ghostty";
                    prompt = "'󰼛  '";
                    cursor-blink = true;
                    
                    # Layout
                    width = 40;
                    tabs = 4;
                    horizontal-pad = 20;
                    vertical-pad = 10;
                    inner-pad = 5;
                    line-height = 25;
                    letter-spacing = 0;
                };

                border = {
                    width = 2;
                    radius = 12;
                };
            };
        };
    };
}
