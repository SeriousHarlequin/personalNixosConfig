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
      nvim-autopairs # for automatic closing bracket
    ];
  };

  home.packages = with pkgs; [
    # Language Servers
    lua-language-server
    nixd
    clang-tools
    rust-analyzer
    pyright

    # Formatters
    stylua
    black
    nixpkgs-fmt
  ];

  # Deploy the Neovim config directory
  xdg.configFile."nvim".source = ./nvim;
}

