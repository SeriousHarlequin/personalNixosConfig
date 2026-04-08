{ lib, config, pkgs, ... }:
let
  cfg = config.myHome.direnv;
in
{
  options.myHome.direnv = {
    enable = lib.mkEnableOption "Enable direnv with nix-direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
