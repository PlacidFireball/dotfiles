return {
  name = "Run Script",
  builder = function()
    local file = vim.fn.expand("%:p")

    local local_state = require("modules.state")
    local tenant = local_state.state.tenant
    local cluster = local_state.state.cluster

    local cmd = { file }
    if vim.bo.filetype == "python" then
      cmd = { "python3", file }
      if cluster ~= nil then
        table.insert(cmd, "-c")
        table.insert(cmd, cluster)
      end
      if tenant ~= nil then
        table.insert(cmd, "-t")
        table.insert(cmd, tenant)
      end
    end

    print(local_state.dump(cmd))

    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      }
    }
  end,
  condition = {
    filetype = { "python", "sh" }
  },
}
