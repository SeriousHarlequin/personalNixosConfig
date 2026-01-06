{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.nvidia;
in
{
  options.myNixos.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia drivers";
    hybrid.enable = lib.mkEnableOption "Enable hybrid laptop graphics";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # General Nvidia Configuration
    {
      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ]; # Removed "modesetting" as it's often redundant here

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = true; # Changed to true since you have a 1660Ti (Turing)
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    }

    # Hybrid/PRIME specific Configuration
    (lib.mkIf cfg.hybrid.enable {
      hardware.nvidia.prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    })
  ]);
}
