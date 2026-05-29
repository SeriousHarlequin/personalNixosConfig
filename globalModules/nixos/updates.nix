{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.autoUpdate;
in
{
  options.myNixos.autoUpdate = {
    enable = lib.mkEnableOption "Enables auto system updates";
    dates = lib.mkOption {
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
        "--commit-lock-file"
      ];
    };

    # deletes all generations older than 30d
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
    # This finds duplicate files in the store and hard-links them to save space
    nix.settings.auto-optimise-store = true;
  };
}
