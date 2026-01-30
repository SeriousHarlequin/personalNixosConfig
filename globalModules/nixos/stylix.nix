{ pkgs, ... }:
{
    stylix.enable = true;

    stylix.image = ./draculaNixos.png;

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    stylix.polarity = "dark";

    stylix.cursor = {
        package = pkgs.vimix-cursors;
        name = "Vimix-cursors";
        size = 32;
    };

    environment.systemPackages = with pkgs; [
        gnomeExtensions.user-themes
        swaybg
    ];

}
