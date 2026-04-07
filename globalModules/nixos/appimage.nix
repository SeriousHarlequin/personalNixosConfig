{ config, lib, ... }:
let
  cfg = config.myNixos.appimage;
in
{
  options.myNixos.appimage = {
    enable = lib.mkEnableOption "AppImage support";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
