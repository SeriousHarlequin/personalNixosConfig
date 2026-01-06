{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.autoUpdate;
in
{
  options.myNixos.autoUpdate = {
    enable = lib.mkEnableOption "Enables auto system updates";
    dates = lib.mkOption {
      # Use 'either' to support both a single string and a list of strings
      type = with lib.types; either str (listOf str);
      default = "04:00";
      example = "weekly";
      description = ''
        How often or at what time the update should run.
        The format is described in systemd.time(7).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      dates = cfg.dates;
      flake = "github:SeriousHarlequin/personalNixosConfig#${config.networking.hostName}";
      flags = [
        "--update-input" "nixpkgs"
        "--update-input" "home-manager"
      ];
    };
  };
}
