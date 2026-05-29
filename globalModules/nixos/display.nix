{ config, lib, ... }:
let
  cfg = config.myNixos.display;
in
{
  options.myNixos.display.enable = lib.mkEnableOption "Enable xserver and GDM";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
  };
}
