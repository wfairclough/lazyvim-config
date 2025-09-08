return {
  {
    -- https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = function()
      return {
        enabled = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<A-l>",
          refresh = "gr",
          open = "<M-CR>",
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<A-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
        },
      }
    end,
    config = function(_, opts)
      require("copilot").setup(opts)
      vim.g.ai_cmp = false
    end,
  },
}
