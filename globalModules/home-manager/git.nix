{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "SeriousHarlequin";
    userEmail = "fabian@schaetzschock.at";
    aliases = {
      st = "status";
      lg = "log --oneline --graph --decorate";
      undo = "reset HEAD~1 --mixed";
    };
    extraConfig = {
      credential.credentialStore = "secretservice";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  home.packages = [ pkgs.git-credential-manager ];
}
