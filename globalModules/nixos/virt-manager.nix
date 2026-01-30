{ lib, config, pkgs, ... }:
let
    cfg = config.myNixos.software.virt-manager;
in
{
    options.myNixos.software.virt-manager = {
        enable = lib.mkEnableOption "Enables Virt-Manager virtualization tools";
    };

    config = lib.mkIf cfg.enable {

        programs.virt-manager.enable = true;

        virtualisation.libvirtd = {
            enable = true;
            qemu = {
                package = pkgs.qemu_kvm;
                runAsRoot = true;
                swtpm.enable = true;
            };
        };

        virtualisation.spiceUSBRedirection.enable = true;

    };
}
