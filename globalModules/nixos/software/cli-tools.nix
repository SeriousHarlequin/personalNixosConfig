{ config, lib, pkgs, ... }:
let
cfg = config.myNixos.software.cli-tools;
in
{
    options.myNixos.software.cli-tools = {
        enable = lib.mkEnableOption "Enables standard cli tools";
    };

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            wget
            neovim
            lf
            git
            tree
            btop
        ];
    };
}
