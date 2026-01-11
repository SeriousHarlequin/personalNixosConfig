vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true

-- indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- UI
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.colorcolumn = "120"

-- performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- clipboard & undo
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- misc
vim.opt.scrolloff = 8
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

