{ config, lib, pkgs, ... }:
let
  cfg = config.myNixos.software.libreoffice;
in
{
  options.myNixos.software.libreoffice = {
    enable = lib.mkEnableOption "Enable the libreoffice suit";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-fresh
      hunspell
      hunspellDicts.de_AT
      hunspellDicts.en_US
    ];
  };
}
