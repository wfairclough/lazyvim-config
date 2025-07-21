-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-refresh files when they change externally
local file_change_group = vim.api.nvim_create_augroup("FileChangeDetection", { clear = true })

-- Check for file changes when entering buffer or gaining focus
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "TermClose", "TermLeave" }, {
  group = file_change_group,
  callback = function()
    if vim.bo.buftype == "" and vim.fn.filereadable(vim.fn.expand("%")) == 1 then
      vim.cmd("checktime")
    end
  end,
})

-- Show warning when file changed externally and buffer has unsaved changes
vim.api.nvim_create_autocmd("FileChangedShell", {
  group = file_change_group,
  callback = function()
    if vim.bo.modified then
      vim.notify(
        "File changed externally but buffer has unsaved changes. Use :e! to reload or save your changes first.",
        vim.log.levels.WARN,
        { title = "File Conflict" }
      )
      -- Don't auto-reload when buffer is modified
      vim.v.fcs_choice = ""
    else
      -- Auto-reload when buffer is not modified
      vim.v.fcs_choice = "reload"
    end
  end,
})
