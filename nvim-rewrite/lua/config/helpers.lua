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


M.spec = get_spec
M.gh = gh
M.po = default_pack_opts
M.get_quiq_directory = get_quiq_directory

return M
