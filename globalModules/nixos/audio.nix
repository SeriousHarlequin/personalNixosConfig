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
      raopOpenFirewall = true;    # opens UDP 6001-6002 for AirPlay timing/control

      extraConfig.pipewire."10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";
            # uncomment + bump if you get dropouts/glitches
            # args = { "raop.latency.ms" = 500; };
          }
        ];
      };
    };
  };
}
