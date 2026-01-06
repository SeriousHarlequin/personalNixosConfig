{ lib, config, pkgs, ... }:
let
  cfg = config.myHome.zoxide;
in
{
  options.myHome.zoxide = {
    enable = lib.mkEnableOption "Enable zoxide aka better cd";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    programs.bash.enable = true;
  };
}
