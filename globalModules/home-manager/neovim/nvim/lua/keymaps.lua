vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- clear search highlight
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

