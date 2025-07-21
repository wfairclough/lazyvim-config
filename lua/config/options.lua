-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-refresh file changes
vim.opt.autoread = true -- Auto-read files when changed outside Neovim

-- Additional options from old config
vim.opt.wrap = false -- Disable line wrapping
vim.opt.swapfile = false -- Disable swap files
vim.opt.smartcase = true -- Smart case searching
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
