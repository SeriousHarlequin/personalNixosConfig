{ config, lib, pkgs, ... }:
let
  cfg = config.myHome.zsh;
in
{
  options.myHome.zsh = {
    enable = lib.mkEnableOption "Enables Zsh shell";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake";
      };
      history.size = 10000;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "web-search"
        ];
        theme = "robbyrussell";
      };
    };
    programs.pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
