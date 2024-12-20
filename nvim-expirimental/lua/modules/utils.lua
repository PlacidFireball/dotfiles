local M = {}

local function table_to_set(table)
  local set = {}
  for _, l in ipairs(table) do set[l] = true end
  return set
end

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local function get_quiq_directory()
  local s = vim.fn.expand("%:p")

  for m in string.gmatch(s, '/Users/jared.weiss/Dev/quiq/[a-z%-]+/') do
    return m
  end

  Snacks.notifier.notify("Could not resolve a quiq directory for scala dap run configuration", vim.log.levels.WARN)
  return '/Users/jared.weiss/Dev/quiq/ring-master/'
end

M.dump = dump
M.table_to_set = table_to_set
M.get_quiq_directory = get_quiq_directory

local clusters = table_to_set({ "dev", "qa", "mqa", "roman", "perf", "stage", "mstage", "demo", "age1", "mva1", "ava1",
  "ava3", "aor1", "aor3" })

M.state = { cluster = nil, tenant = nil, floating_terminal = { buf = -1, win = -1 } }
local function set_cluster(cluster)
  if not clusters[cluster] then
    Snacks.notifier.notify((cluster or "NONE") .. " is not a valid cluster", vim.log.levels.WARN)
    return
  end

  M.state.cluster = cluster
end


local function set_tenant(tenant)
  if not tenant then
    Snacks.notifier.notify("Tenant may not be empty/nil", vim.log.levels.WARN)
    return
  end
  M.state.tenant = tenant
end


vim.api.nvim_create_user_command("SetCluster", function(args)
  local args_list = args.fargs
  local cluster = args_list[1]

  set_cluster(cluster)
end, { nargs = 1 })


vim.api.nvim_create_user_command("SetTenant", function(args)
  local args_list = args.fargs
  local tenant = args_list[1]

  set_tenant(tenant)
end, { nargs = 1 })


local function get_floating_window(opts)
  -- Default values
  opts = opts or {}
  local width_percent = opts.width or 80
  local height_percent = opts.height or 80

  -- Get editor width and height
  local width = math.floor(vim.api.nvim_get_option_value("columns", {}) * width_percent / 100)
  local height = math.floor(vim.api.nvim_get_option_value("lines", {}) * height_percent / 100)

  -- Calculate starting position
  local row = math.floor((vim.api.nvim_get_option_value("lines", {}) - height) / 2)
  local col = math.floor((vim.api.nvim_get_option_value("columns", {}) - width) / 2)

  -- Window configuration
  local win_opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded"
  }

  -- Create buffer
  local buf = -1
  if opts.buf ~= -1 and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Add content if provided
  if opts.content then -- a table of strings
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.content)
  end

  -- Create window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return { buf = buf, win = win }
end

M.get_floating_window = get_floating_window

vim.api.nvim_create_user_command("ToggleTerminal", function()
  if not vim.api.nvim_win_is_valid(M.state.floating_terminal.win) then
    M.state.floating_terminal = get_floating_window({
      buf = M.state.floating_terminal.buf,
    })
    if vim.bo[M.state.floating_terminal.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(M.state.floating_terminal.win)
  end
end, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", "<CMD>ToggleTerminal<CR>", { desc = "[T]oggle floating [T]erminal" })

return M
