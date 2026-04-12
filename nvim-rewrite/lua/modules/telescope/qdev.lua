local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

local function run_qdev_picker(opts)
  opts = opts or {}
  
  pickers.new(opts, {
    prompt_title = "qdev commands",
    finder = finders.new_oneshot_job({ "qdev", "--enumerate" }, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if not selection then return end

        local line = selection.value or selection[1]
        local cmd = {}
        for word in string.gmatch(line, "%S+") do
          if word:match("^%[") or word:match("^%-") or word:match("^<") then
            break
          end
          table.insert(cmd, word)
        end

        if cmd[1] == "qdev" then
          table.insert(cmd, 2, "-i")
        end

        -- Run the command in a floating terminal using Snacks
        Snacks.terminal.toggle(cmd, {
          auto_close = false,
          start_insert = true,
          auto_insert = true,
          win = {
            border = 'rounded',
            keys = {}
          }
        })
      end)
      return true
    end,
  }):find()
end

M.setup = function(opts)
  vim.keymap.set("n", "<leader>sq", function() run_qdev_picker(opts) end, { desc = '[S]earch [Q]dev commands' })
end

return M
