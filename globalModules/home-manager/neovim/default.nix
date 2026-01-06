{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      luasnip
      gitsigns-nvim
    ];
  };

  # Deploy the Neovim config directory
  xdg.configFile."nvim".source = ./nvim;
}

