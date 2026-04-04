local h = require('config.helpers')

vim.pack.add(h.spec('stevearc/oil.nvim', 'oil'), h.po())

require('oil').setup {
 view_options = {
    show_hidden = true,
  },
  git = {
    add = function()
      return true
    end,
    mv = function()
      return true
    end,
    rm = function()
      return true
    end,
  },
  watch_for_changes = true,
}

vim.keymap.set('n', '<leader>O', ":Oil<CR>", { desc = '[O]il' })
