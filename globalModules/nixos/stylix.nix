{ pkgs, ... }:
{
    stylix.enable = true;

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";


    environment.systemPackages = with pkgs; [
        gnomeExtensions.user-themes
    ];
}
