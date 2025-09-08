return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        -- preview = {
        --   filesize_limit = 0.1, -- MB
        --   mime_hook = function(filepath, bufnr, opts)
        --     local is_image = require("telescope.previewers.utils").is_binary_file(filepath)
        --     if is_image then
        --       vim.schedule(function()
        --         vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Binary file preview disabled" })
        --       end)
        --       return false
        --     end
        --     return true
        --   end,
        -- },
        -- Include hidden files in searches
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- Add this to search hidden files
          "--glob",
          "!**/.git/*", -- Exclude .git directory
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- Show hidden files in find_files
          git_ignore = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          hidden = true,
          additional_args = function()
            return { "--hidden", "--glob", "!**/.git/*" }
          end,
        },
        grep_string = {
          additional_args = function()
            return { "--hidden", "--glob", "!**/.git/*" }
          end,
        },
      },
    },
    config = function(_, opt)
      local builtin = require("telescope.builtin")
      -- toggle the hidden files in the open file picker
      vim.keymap.set("n", "<C-h>", function()
        local opts = { hidden = not vim.o.hidden }
        builtin.find_files(opts)
      end, { desc = "Toggle Hidden Files" })
    end,
  },
}
