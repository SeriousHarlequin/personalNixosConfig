# Neovim Keymaps

Leader key: `Space`

## Navigation

| Keymap | Action |
|--------|--------|
| `<C-h/j/k/l>` | Move between splits |
| `<leader>h` | Clear search highlight |

## Telescope (Fuzzy Finder)

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search file contents) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |

## LSP (Language Intelligence)

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gr` | List all references |
| `gi` | Go to implementation |
| `K` | Show documentation hover |
| `<leader>rn` | Rename symbol across project |
| `<leader>ca` | Code actions (auto-import, fixes) |
| `<leader>f` | Format file |

## Diagnostics (Errors & Warnings)

| Keymap | Action |
|--------|--------|
| `]d` | Jump to next diagnostic |
| `[d` | Jump to previous diagnostic |
| `<leader>d` | Show diagnostic for current line |
| `<leader>xx` | Toggle Trouble diagnostic list |

## Commenting

| Keymap | Action |
|--------|--------|
| `gcc` | Toggle comment on current line |
| `gc` + motion | Toggle comment on motion (e.g. `gc5j` = 5 lines) |
| `gc` (visual) | Toggle comment on selection |

## File Explorer

| Keymap | Action |
|--------|--------|
| `<leader>e` | Open Oil file explorer |
