{ config, lib, pkgs, ... }:
let
cfg = config.myNixos.software.java-dev-tools;
in
{
    options.myNixos.software.java-dev-tools = {
        enable = lib.mkEnableOption "Java Dev Tools";
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
        jetbrains.idea
        jdk21
        ];
    };
}
