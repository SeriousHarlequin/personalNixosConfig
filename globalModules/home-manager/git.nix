{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "SeriousHarlequin";
      user.email = "fabian@schaetzschock.at";
      alias = {
        st = "status";
        lg = "log --oneline --graph --decorate";
        undo = "reset HEAD~1 --mixed";
      };
      credential.credentialStore = "secretservice";
      pull.rebase = true;
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  home.packages = [ pkgs.git-credential-manager ];
}
