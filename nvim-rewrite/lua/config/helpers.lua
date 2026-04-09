local M = {}

--@param src string
local function gh(src)
  return 'https://github.com/' .. src
end

---comment
---@param src string
---@param name? string|nil
---@param version? string|nil
---@return vim.pack.Spec
local function get_spec(src, name, version)
  return {{
    src = gh(src),
    name = name,
    version = version
  }}
end

---Get the default package options
---@return vim.pack.keyset.add
local function default_pack_opts()
  return { confirm = false, load = true }
end

local function get_quiq_directory()
  local s = vim.fn.expand("%:p")

  for m in string.gmatch(s, '/Users/jared.weiss/Dev/quiq/[a-z%-]+/') do
    return m
  end

  Snacks.notifier.notify("Could not resolve a quiq directory for scala dap run configuration", vim.log.levels.WARN)
  return '/Users/jared.weiss/Dev/quiq/ring-master/'
end

local function table_to_set(table)
  local set = {}
  for _, l in ipairs(table) do set[l] = true end
  return set
end

---run a terminal command
---@param cmd string|string[]
---@param opts_in snacks.terminal.Opts|nil
local function run_terminal_command(cmd, opts_in)
  local default_win = {
    style = "float",
    width = 0.8,
    height = 0.8,
    border = "rounded",
  }

  local opts = opts_in or {
    interactive = false,
    win = default_win,
  }

  Snacks.terminal.open(cmd, opts)
end


M.spec = get_spec
M.gh = gh
M.po = default_pack_opts
M.get_quiq_directory = get_quiq_directory
M.table_to_set = table_to_set
M.run_terminal_command = run_terminal_command

return M
