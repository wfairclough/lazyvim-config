return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = {
      timeout = 5000, -- 5 seconds (default is 3000)
      -- Set to 0 for no timeout (manual dismiss only)
    },
    input = { enabled = false },
    words = { enabled = false },
    -- picker = {
    --   enabled = true,
    --   preview = { enabled = false },
    -- },
  },
}
