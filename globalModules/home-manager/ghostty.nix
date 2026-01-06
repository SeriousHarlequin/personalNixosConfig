{ config, lib, pkgs, ...}:

let
  cfg = config.myHome.ghostty;
in 

{
  options.myHome.ghostty = {
    enable = lib.mkEnableOption "Custom Ghostty configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ghostty ];

    xdg.configFile."ghostty/config".text = ''
      # --- Appearance ---
      theme = Dracula
      font-family = "JetBrainsMono Nerd Font"
      font-size = 12
      fullscreen = true

      # Window styling
      window-decoration = false
      background-opacity = 0.9
      background-blur = true

      # --- Cursor & Interaction ---
      cursor-style = block
      cursor-style-blink = true
      mouse-hide-while-typing = true
      copy-on-select = clipboard

      # Prevents annoying confirmation popups
      confirm-close-surface = false

      # --- Keybindings ---
      # Quick split management
      keybind = ctrl+shift+e=new_split:right
      keybind = ctrl+shift+o=new_split:down

      # Quick navigation between splits (Vim style)
      keybind = ctrl+h=goto_split:left
      keybind = ctrl+l=goto_split:right
      keybind = ctrl+j=goto_split:bottom
      keybind = ctrl+k=goto_split:top

      # Ghostty Split Resizing with Ctrl+Shift+HJKL
      keybind = ctrl+shift+h=resize_split:left,50
      keybind = ctrl+shift+j=resize_split:down,50
      keybind = ctrl+shift+k=resize_split:up,50
      keybind = ctrl+shift+l=resize_split:right,50
      keybind = ctrl+shift+z=toggle_split_zoom
    '';
  };
}
