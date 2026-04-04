local h = require('config.helpers')

vim.pack.add(h.spec('folke/which-key.nvim', 'which-key'), h.po())

require('which-key').setup {}

vim.keymap.set('n', '<leader>?', function() require('which-key').show({global=false}) end, { desc = 'Buffer Local Keymaps' })
