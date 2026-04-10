local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-j>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-k>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-J>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A-K>', '<Cmd>BufferMoveNext<CR>', opts)

map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
map('n', '<C-q>', '<Cmd>BufferClose<CR>', opts)
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>', opts)

return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    -- https://github.com/romgrk/barbar.nvim?tab=readme-ov-file#options
  },
  version = '^1.0.0',   -- optional: only update when a new 1.x version is released
}
