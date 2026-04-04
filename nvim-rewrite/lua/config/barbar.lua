local h = require('config.helpers')

vim.pack.add(h.spec('nvim-tree/nvim-web-devicons', 'nvim-web-devicons'), h.po())
vim.pack.add(h.spec('lewis6991/gitsigns.nvim', 'gitsigns'), h.po())
vim.pack.add(h.spec('romgrk/barbar.nvim', 'barbar'), h.po())

require('nvim-web-devicons').setup()

require('barbar').setup {
  icons = {
    diagnostics = {
      enabled = true
    }
  },
  insert_at_end = true,
}

vim.keymap.set('n', '<A-j>', ':BufferPrevious<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<A-k>', ':BufferNext<CR>', { desc = 'Previous Buffer' })

vim.keymap.set('n', '<A-J>', ':BufferMovePrevious<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<A-K>', ':BufferMoveNext<CR>', { desc = 'Previous Buffer' })

vim.keymap.set('n', '<C-q>', ':BufferClose<CR>', { desc = 'Buffer Close' })
