{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      luasnip
      fidget-nvim
      gitsigns-nvim
      nvim-autopairs
      oil-nvim
      indent-blankline-nvim
      todo-comments-nvim
      trouble-nvim
      nvim-web-devicons
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
    nixfmt-rfc-style

    ripgrep # for <leader> fg grep through files
  ];

  # Deploy the Neovim config directory
  xdg.configFile."nvim".source = ./nvim;
}

