{ config, lib, pkgs, ... }:
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
      package = pkgs.appimage-run.override {
        extraPkgs = p: [
          p.libffi
          p.libyaml
          p.SDL2
          p.SDL2_image
          p.SDL2_mixer
          p.SDL2_ttf
          p.libGL
          p.openal
          p.libvorbis
          p.libogg
        ];
      };
    };
  };
}
