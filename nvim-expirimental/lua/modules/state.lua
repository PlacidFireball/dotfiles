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

M.dump = dump
M.table_to_set = table_to_set

M.state = { cluster = nil, tenant = nil }
local function set_cluster(cluster)
  local valid_clusters = { "dev", "qa", "mqa", "roman", "perf", "stage", "mstage", "demo", "age1", "mva1", "ava1", "ava3",
    "aor1", "aor3" }

  local set = table_to_set(valid_clusters)

  if not set[cluster] then
    print("Not a valid cluster")
    return
  end

  M.state.cluster = cluster
end

local function set_tenant(tenant)
  if not tenant then
    print("When setting a tenant it must be non-empty/not nil")
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

return M
