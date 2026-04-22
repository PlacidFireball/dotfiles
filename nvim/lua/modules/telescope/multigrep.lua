local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local M = {}


---@param opts? { cwd?: string, extra_rg_opts: string[] }
local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, "|")
      local args = { "rg" }

      if pieces[1] then
        table.insert(args, '-e')
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, '-g')
        table.insert(args, pieces[2])
      end

      vim.list_extend(args, { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' })
      vim.list_extend(args, opts.extra_rg_opts or {})

      return args
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Multi Grep",
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require('telescope.sorters').empty()
  }):find()
end

M.setup = function(opts)
  vim.keymap.set("n", "<leader>sg", function() live_multigrep(opts) end, { desc = '[S]earch with [G]rep' })
  vim.keymap.set('n', '<leader>gn', function() live_multigrep({ cwd = vim.fn.stdpath('config') }) end, { desc = '[G]rep neovim'})
  vim.keymap.set('n', '<leader>gp', function() live_multigrep({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') }) end, { desc = '[G]rep neovim'})
  vim.keymap.set('n', '<leader>g.c', function() live_multigrep({ cwd = '/Users/jared.weiss/.centricient/' }) end, { desc = '[G]rep .centricient'})
end

return M
