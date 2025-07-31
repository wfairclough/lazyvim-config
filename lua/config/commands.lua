-- Custom commands for my neovim setup
--

-- Project-wide find and replace using grug-far
local function project_find_replace(args)
  -- Parse the pattern %s/search/replace/flags
  local pattern = args.args
  if not pattern or pattern == "" then
    vim.notify("Usage: :ProjectFindReplace %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  -- Extract search, replace, and flags from the pattern
  local delimiter = pattern:sub(3, 3) -- Get delimiter after %s
  if delimiter == "" then
    vim.notify("Invalid pattern. Use format: %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  local parts = {}
  local current = ""
  local escape_next = false
  local part_index = 1

  -- Skip %s and delimiter
  for i = 4, #pattern do
    local char = pattern:sub(i, i)

    if escape_next then
      current = current .. char
      escape_next = false
    elseif char == "\\" then
      current = current .. char
      escape_next = true
    elseif char == delimiter then
      table.insert(parts, current)
      current = ""
      part_index = part_index + 1
      if part_index > 3 then
        break
      end
    else
      current = current .. char
    end
  end

  -- Add the last part (flags)
  if current ~= "" or part_index <= 3 then
    table.insert(parts, current)
  end

  if #parts < 2 then
    vim.notify("Invalid pattern. Use format: %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  local search_term = parts[1]
  local replace_term = parts[2] or ""
  local flags = parts[3] or ""

  if search_term == "" then
    vim.notify("Search term cannot be empty", vim.log.levels.ERROR)
    return
  end

  -- Open grug-far with the parsed terms
  require("grug-far").open({
    prefills = {
      search = search_term,
      replacement = replace_term,
      flags = flags:match("i") and "i" or "", -- Only support case-insensitive flag for now
    },
  })
end

-- Create the command
vim.api.nvim_create_user_command("ProjectFindReplace", project_find_replace, {
  nargs = 1,
  desc = "Project-wide find and replace using grug-far (%s/search/replace/flags)",
})

-- Quick project-wide search command
vim.api.nvim_create_user_command("ProjectFind", function(args)
  if not args.args or args.args == "" then
    vim.notify("Usage: :ProjectFind <search_term>", vim.log.levels.ERROR)
    return
  end

  require("grug-far").open({
    prefills = {
      search = args.args,
    },
  })
end, {
  nargs = 1,
  desc = "Project-wide search using grug-far",
})

-- Enhanced project replace with confirmation
vim.api.nvim_create_user_command("ProjectReplaceAll", function(args)
  local pattern = args.args
  if not pattern or pattern == "" then
    vim.notify("Usage: :ProjectReplaceAll %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  -- Same parsing logic as ProjectFindReplace
  local delimiter = pattern:sub(3, 3)
  if delimiter == "" then
    vim.notify("Invalid pattern. Use format: %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  local parts = {}
  local current = ""
  local escape_next = false
  local part_index = 1

  for i = 4, #pattern do
    local char = pattern:sub(i, i)

    if escape_next then
      current = current .. char
      escape_next = false
    elseif char == "\\" then
      current = current .. char
      escape_next = true
    elseif char == delimiter then
      table.insert(parts, current)
      current = ""
      part_index = part_index + 1
      if part_index > 3 then
        break
      end
    else
      current = current .. char
    end
  end

  if current ~= "" or part_index <= 3 then
    table.insert(parts, current)
  end

  if #parts < 2 then
    vim.notify("Invalid pattern. Use format: %s/search/replace/flags", vim.log.levels.ERROR)
    return
  end

  local search_term = parts[1]
  local replace_term = parts[2] or ""

  if search_term == "" then
    vim.notify("Search term cannot be empty", vim.log.levels.ERROR)
    return
  end

  -- Confirm before replacing all
  local confirm = vim.fn.confirm(
    string.format("Replace all occurrences of '%s' with '%s' in the project?", search_term, replace_term),
    "&Yes\n&No",
    2
  )

  if confirm == 1 then
    require("grug-far").open({
      prefills = {
        search = search_term,
        replacement = replace_term,
        flags = parts[3] or "",
      },
    })
    -- Auto-trigger replace all after a short delay
    vim.defer_fn(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Enter>", true, false, true), "n", false)
    end, 100)
  end
end, {
  nargs = 1,
  desc = "Project-wide find and replace all with confirmation",
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
