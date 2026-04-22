local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

--- Extract the identifier name from a captured node.
--- Tries the "name" field first (works for class/object/trait definitions),
--- then falls back to the first identifier child (covers val/var patterns).
local function get_name(node, bufnr)
  local name_nodes = node:field("name")
  if name_nodes and #name_nodes > 0 then
    return vim.treesitter.get_node_text(name_nodes[1], bufnr)
  end
  for child in node:iter_children() do
    local t = child:type()
    if t == "identifier" or t == "type_identifier" then
      return vim.treesitter.get_node_text(child, bufnr)
    end
  end
  -- last resort: first line of the node text
  return vim.treesitter.get_node_text(node, bufnr):match("[^\n]+")
end

---@param opts? { capture: string|nil, title: string }
M.pick = function(opts)
  opts = opts or {}
  local capture = opts.capture  -- nil means all captures
  local title = opts.title or "Pick"

  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local root = parser:parse()[1]:root()

  local query = vim.treesitter.query.get(lang, "symbols")
  if not query then
    vim.notify("No symbols.scm query found for language: " .. (lang or vim.bo[bufnr].filetype), vim.log.levels.WARN)
    return
  end

  local results = {}
  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    local kind = query.captures[id]
    if capture == nil or kind == capture then
      local row, col = node:start()
      local name = get_name(node, bufnr)
      local full_text = vim.treesitter.get_node_text(node, bufnr)
      table.insert(results, { name = name, kind = kind, full_text = full_text, row = row, col = col })
    end
  end

  local ts_previewer = previewers.new_buffer_previewer({
    title = "Preview",
    define_preview = function(self, entry)
      local lines = vim.split(entry.value.full_text, "\n")
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      vim.treesitter.start(self.state.bufnr, lang)
    end,
  })

  pickers.new({}, {
    prompt_title = title,
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        local label = capture == nil
          and string.format("[%s] %s", entry.kind, entry.name)
          or entry.name
        return {
          value = entry,
          display = label,
          ordinal = label,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = ts_previewer,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local sel = action_state.get_selected_entry()
        vim.api.nvim_win_set_cursor(0, { sel.value.row + 1, sel.value.col })
      end)
      return true
    end,
  }):find()
end

M.setup = function()
  vim.keymap.set("n", "<leader>tv", function() M.pick({ capture = "variable", title = "Variables" }) end,  { desc = "[T]reesitter [V]ariables" })
  vim.keymap.set("n", "<leader>tc", function() M.pick({ capture = "type",     title = "Types" }) end,      { desc = "[T]reesitter [T]ypes" })
  vim.keymap.set("n", "<leader>tf", function() M.pick({ capture = "function", title = "Functions" }) end,  { desc = "[T]reesitter [F]unctions" })
  vim.keymap.set("n", "<leader>ts", function() M.pick({ title = "Symbols" }) end,                          { desc = "[T]reesitter [S]earch" })
end

return M
