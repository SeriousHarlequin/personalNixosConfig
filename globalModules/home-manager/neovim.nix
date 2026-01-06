{ config, pkgs, ... }:

{
    programs.neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;

        extraLuaConfig = ''
            vim.opt.number = true
            vim.opt.relativenumber = true
            vim.opt.expandtab = true

            -- indentation
            vim.opt.shiftwidth = 2
            vim.opt.tabstop = 2
            vim.opt.smartindent = true

            -- searching
            vim.opt.ignorecase = true
            vim.opt.smartcase = true
            vim.opt.incsearch = true

            -- UI
            vim.opt.cursorline = true
            vim.opt.signcolumn = "yes"
            vim.opt.wrap = false

            -- faster updates
            vim.opt.updatetime = 250
            vim.opt.timeoutlen = 400

            -- clipboard integration
            vim.opt.clipboard = "unnamedplus"

            -- undo history
            vim.opt.undofile = true

            -- splits
            vim.opt.splitbelow = true
            vim.opt.splitright = true

            vim.g.mapleader = " "
            vim.g.maplocalleader = " "

            -- better window navigation
            vim.keymap.set("n", "<C-h>", "<C-w>h")
            vim.keymap.set("n", "<C-j>", "<C-w>j")
            vim.keymap.set("n", "<C-k>", "<C-w>k")
            vim.keymap.set("n", "<C-l>", "<C-w>l")

            -- clear search highlight
            vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep)
            vim.keymap.set("n", "<leader>fb", builtin.buffers)
            vim.keymap.set("n", "<leader>fh", builtin.help_tags")

            require("nvim-treesitter.configs").setup {
            highlight = { enable = true },
            indent = { enable = true },
            }

            -- keep cursor centered
            vim.opt.scrolloff = 8

            -- better completion menu
            vim.opt.completeopt = { "menu", "menuone", "noselect" }

            -- show whitespace issues
            vim.opt.list = true
            vim.opt.listchars = {
            tab = "» ",
            trail = "·",
            nbsp = "␣",
            }

        '';

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
}
