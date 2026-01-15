{ config, lib, pkgs, ...}:
let
    cfg = config.myHome.niri;
in
{
    options.myHome.niri = {
        enable = lib.mkEnableOption "Enable Niri styling for user";
    };

    config = lib.mkIf cfg.enable {
        xdg.configFile."./config.kdl".source = ./config.kdl;
    };
}
