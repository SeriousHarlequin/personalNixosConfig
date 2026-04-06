{ config, lib, ... }:
let
  cfg = config.myNixos.audio;
in
{
  options.myNixos.audio.enable = lib.mkEnableOption "Enable pipewire audio";

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
