-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto-refresh file changes
vim.opt.autoread = true -- Auto-read files when changed outside Neovim

-- Additional options from old config
vim.opt.wrap = false -- Disable line wrapping
vim.opt.swapfile = false -- Disable swap files
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Disable smooth scrolling animation
vim.g.snacks_animate_scroll = false

-- Enable auto-reload of files when they change
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})

vim.keymap.set("n", "<leader>ar", function()
  -- local handle = io.popen("aws-vault exec sandbox-admin -- env | grep -E '^AWS_'")
  local handle = io.popen("aws-vault export --format=env sandbox-admin")
  if handle then
    local result = handle:read("*a")
    handle:close()

    local keys = {}
    for line in result:gmatch("[^\r\n]+") do
      local key, value = line:match("^([^=]+)=(.*)$")
      if key and value then
        table.insert(keys, key)
        vim.fn.setenv(key, value)
      end
    end

    vim.cmd("luafile ~/.config/nvim/init.lua")
    vim.notify(
      "AWS environment variables (" .. table.concat(keys, ", ") .. ") loaded and plugins reloaded",
      vim.log.levels.INFO
    )
  else
    vim.notify("Failed to execute aws-vault command", vim.log.levels.ERROR)
  end
end, { desc = "Load AWS env vars and reload plugins" })
