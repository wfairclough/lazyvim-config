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

-- Disable smooth scrolling animation
vim.g.snacks_animate_scroll = false

-- Enable auto-reload of files when they change
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})
