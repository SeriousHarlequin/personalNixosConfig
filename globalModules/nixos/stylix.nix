{ pkgs, ... }:
{
    stylix.enable = true;

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    stylix.polarity = "dark";

    environment.systemPackages = with pkgs; [
        gnomeExtensions.user-themes
    ];
}
