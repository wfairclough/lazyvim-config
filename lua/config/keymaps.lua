-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Write current buffer
vim.keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = "Write current buffer" })

-- Write all open buffers
vim.keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Write all open buffers" })

-- Quit all
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })

-- Close current buffer
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- Additional keymaps from old config
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>qw", ":wqa<CR>", { desc = "Write/Quit All" })
vim.keymap.set("n", "<leader>qf", "<cmd>qa!<CR>", { desc = "Quit All Force" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Focus window left" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Focus window right" })
vim.keymap.set("n", "<leader>vf", "ggVG", { desc = "Visually select entire file" })
vim.keymap.set("n", "<leader>yf", 'ggVG"+y', { desc = "Yank entire file" })
vim.keymap.set("n", ";", ":", { nowait = true, desc = "Command mode shortcut" })

-- Scroll and center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "Scroll up and center" })

-- File path copying functions
vim.keymap.set("n", "<leader>yp", function()
  vim.cmd("let @+ = expand('%:p')")
  vim.notify("Copied full path: " .. vim.fn.expand('%:p'))
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>yt", function()
  vim.cmd("let @+ = expand('%:t')")
  vim.notify("Copied filename: " .. vim.fn.expand('%:t'))
end, { desc = "Copy filename" })

vim.keymap.set("n", "<leader>yd", function()
  vim.cmd("let @+ = expand('%:p:h')")
  vim.notify("Copied directory: " .. vim.fn.expand('%:p:h'))
end, { desc = "Copy directory path" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- C-style block operations
vim.keymap.set("n", "dac", "da{dd", { desc = "Delete around {} and current line" })
vim.keymap.set("n", "yac", "ya{", { desc = "Yank around {}" })

-- Disable some default mappings
vim.keymap.set("n", "J", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Up>", "<Nop>", { silent = true })

-- GitHub integration
local function open_in_github()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local command = "gh browse " .. file .. ":" .. line
  vim.cmd("!" .. command)
end

vim.api.nvim_create_user_command("OpenGitHub", open_in_github, {})
vim.keymap.set("n", "<leader>gh", ":OpenGitHub<CR>", { desc = "Open file in GitHub" })

-- Open URL or Linear ticket under cursor
local function open_url()
  local open_fn = function(uri)
    -- Use the appropriate command based on the operating system
    local opener = "xdg-open" -- Default for Linux
    if vim.fn.has("macunix") == 1 then
      opener = "open" -- For macOS
    elseif vim.fn.has("win32") == 1 then
      opener = "start" -- For Windows
    end
    -- Execute the command to open the URL
    os.execute(opener .. " " .. vim.fn.shellescape(uri))
  end

  -- Get the url text under the cursor
  local url = vim.fn.expand("<cfile>")
  -- Check if the word is a valid URL
  if url:match("^https?://") then
    open_fn(url)
    return
  end

  -- Get the non-whitespace word under the cursor
  local ticket = vim.fn.expand("<cWORD>")

  -- If matches a Linear ticket pattern then open with browser to linear
  if
    ticket:match("^(DEVEX)%-[%d]+")
    or ticket:match("^(COR)%-[%d]+")
    or ticket:match("^(DATA)%-[%d]+")
    or ticket:match("^(AII)%-[%d]+")
    or ticket:match("^(AND)%-[%d]+")
    or ticket:match("^(ARC)%-[%d]+")
    or ticket:match("^(SEC)%-[%d]+")
    or ticket:match("^(BUGS)%-[%d]+")
    or ticket:match("^(APP)%-[%d]+")
  then
    local linear_url = "linear://linear.app/issue/" .. ticket
    print("linear_url", linear_url)
    open_fn(linear_url)
    return
  end

  print("No valid URL under cursor")
end

vim.keymap.set("n", "gx", open_url, { desc = "Open URL or Linear ticket under cursor" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines (with Shift+Alt)
vim.keymap.set("n", "<S-A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<S-A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<S-A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<S-A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<S-A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<S-A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>X", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- Diagnostics
vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open diagnostic" })
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })

-- Center screen after jump commands
vim.keymap.set("n", "<C-o>", "<C-o>zz", { silent = true })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { silent = true })
