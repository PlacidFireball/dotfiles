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

local function run_terminal_command(cmd, opts)

  local default_win = {
    style = "float",
    width = 0.8,
    height = 0.8,
    border = "rounded",
  }

  local opts = opts or {
    auto_close = true,
    win = default_win,
  }

  Snacks.terminal.open(cmd, opts)
end


M.dump = dump
M.table_to_set = table_to_set
M.get_quiq_directory = get_quiq_directory
M.run_terminal_command = run_terminal_command

return M
