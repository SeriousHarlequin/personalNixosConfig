{ config, lib, pkgs, ... }:
let
  cfg = config.myHome.zsh;
in
{
  options.myHome.zsh = {
    enable = lib.mkEnableOption "Enables Zsh shell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.eza ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake github:SeriousHarlequin/personalNixosConfig";
      };
      history.size = 10000;

      plugins = [
        {
          name = "nix-zsh-completions";
          src = pkgs.nix-zsh-completions;
          file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        }
      ];

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "web-search"
          "history-substring-search"
          "colored-man-pages"
          "colorize"
          "dirhistory"
          "eza"
        ];
        theme = "bira";
      };
    };

    programs.pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
