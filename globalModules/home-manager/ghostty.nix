{ config, lib, pkgs, ... }:

let
    cfg = config.myHome.ghostty;
in
{
    options.myHome.ghostty = {
        enable = lib.mkEnableOption "Custom Ghostty configuration";
    };

    config = lib.mkIf cfg.enable {
        # The official module handles adding the package to your path
        programs.ghostty = {
            enable = true;
            
            # The 'settings' attrset is converted into the ghostty config format
            settings = {
                # --- Appearance ---
                font-family = "JetBrainsMono Nerd Font";
                font-size = 12;
                window-decoration = false;
                background-opacity = 0.9;
                background-blur = true;

                # --- Cursor & Interaction ---
                cursor-style = "block";
                cursor-style-blink = true;
                mouse-hide-while-typing = true;
                copy-on-select = "clipboard";

                # Prevents annoying confirmation popups
                confirm-close-surface = false;

                # --- Keybindings ---
                # For keys that appear multiple times, use a list
                keybind = [
                    "ctrl+shift+e=new_split:right"
                    "ctrl+shift+o=new_split:down"
                    
                    # Quick navigation between splits
                    "ctrl+h=goto_split:left"
                    "ctrl+l=goto_split:right"
                    "ctrl+j=goto_split:bottom"
                    "ctrl+k=goto_split:top"

                    # Resizing
                    "ctrl+shift+h=resize_split:left,50"
                    "ctrl+shift+j=resize_split:down,50"
                    "ctrl+shift+k=resize_split:up,50"
                    "ctrl+shift+l=resize_split:right,50"
                    "ctrl+shift+z=toggle_split_zoom"
                ];
            };
        };
    };
}
