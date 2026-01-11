-- TELESCOPE (Fuzzy Finder)
-- Provides the UI for searching files, text, and help tags.
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)

-- TREESITTER (Syntax & Indentation)
-- Provides high-performance syntax highlighting and intelligent indentation.
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent = { enable = true },
}

-- LSP CONFIG (Language Intelligence)
-- Uses the new Neovim 0.11+ native configuration to avoid deprecation warnings.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'lua_ls', 'nixd', 'clangd', 'rust_analyzer', 'pyright' }

for _, lsp in ipairs(servers) do
  -- Using the new native vim.lsp.config instead of require('lspconfig')
  vim.lsp.config(lsp, {
    capabilities = capabilities,
  })
  -- Start the server for the current buffer
  vim.lsp.enable(lsp)
end

-- MANUAL FORMATTING KEYMAP
-- Triggers code formatting only when you press Space + f.
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Manual Format" })

-- COMPLETION & SNIPPETS (Autocomplete Menu)
-- Manages the dropdown menu and handles function snippet expansion.
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  })
})

-- AUTOPAIRS (Bracket Management)
-- Automatically inserts closing brackets while you type.
require("nvim-autopairs").setup {
  check_ts = true, 
}

-- Hook autopairs to completion: adds "()" automatically after selecting a function.
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- GITSIGNS (Git Integration)
-- Shows git change indicators in the gutter.
require('gitsigns').setup()
