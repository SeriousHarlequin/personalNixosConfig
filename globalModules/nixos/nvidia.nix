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
      hardware.graphics.enable32Bit = true;

      services.xserver.videoDrivers = [ "nvidia" ]; # Removed "modesetting" as it's often redundant here

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;

        open = false; # Changed to true since you have a 1660Ti (Turing)
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
    }

    # Hybrid/PRIME specific Configuration
    (lib.mkIf cfg.hybrid.enable {
      hardware.nvidia = {
        # powerManagement.finegrained = true;
        
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    })
    
  ]);
}
