{config, lib, pkgs, ...}:
let
    cfg = config.myNixos.desktopEnvironments;
    isEnabled = name: lib.elem name cfg.enableList;
in
{
    options.myNixos.desktopEnvironments = {
        enableList = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of desktop environments to enable (e.g., [ \"gnome\" \"niri\" \"xfce\" ])";
        };
    };

    config = lib.mkMerge [
        # GNOME
        (lib.mkIf (isEnabled "gnome") {
          services.desktopManager.gnome.enable = true;
        })

        (lib.mkIf (isEnabled "niri"){
            programs.niri.enable = true;
            security.polkit.enable = true; # polkit
            services.gnome.gnome-keyring.enable = true; # secret service
            security.pam.services.swaylock = {};

            programs.waybar.enable = true; # top bar
            environment.systemPackages = with pkgs; [
                fuzzel
                mako
                swayidle
                xwayland-satellite
                networkmanager_dmenu
            ];

            fonts.packages = with pkgs; [
                nerd-fonts.jetbrains-mono
                nerd-fonts.symbols-only # Optional: if you want icons separate from text
            ];
        })
    ];

}
