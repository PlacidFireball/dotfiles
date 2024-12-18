local M = {}

local function map(mode, keybind, action, desc)
  vim.keymap.set(mode, keybind, action, { desc = desc })
end

M.setup = function(opts)
  map('n', '<M-n>', '<CMD>cnext<CR>', 'Quickfix Next')
  map('n', '<M-p>', '<CMD>cprev<CR>', 'Quickfix Previous')

  map('n', '<Esc>', '<CMD>nohlsearch<CR>', '')

  vim.keymap.set('n', '<leader>r', ':.lua<CR>')
  vim.keymap.set('v', '<leader>r', ':.lua<CR>')

  vim.keymap.set('n', '<M-v>', '<CMD>:vsplit<CR>')
  vim.keymap.set('n', '<M-o>', '<CMD>:split<CR>')

  -- Diagnostic keymaps
  map('n', '[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
  map('n', ']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
  map('n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
  map('n', '<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

  -- Esc Esc to escape terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  vim.keymap.set('n', '=', [[<cmd>vertical resize +5<cr>]])   -- make the window biger vertically
  vim.keymap.set('n', '-', [[<cmd>vertical resize -5<cr>]])   -- make the window smaller vertically
  vim.keymap.set('n', '+', [[<cmd>horizontal resize +5<cr>]]) -- make the window bigger horizontally by pressing shift and =
  vim.keymap.set('n', '_', [[<cmd>horizontal resize -5<cr>]]) -- make the window smaller horizontally by pressing shift and -

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

return M
