-- vim options I like --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 5
vim.opt.foldenable = false
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.winborder = 'rounded'

vim.diagnostic.config {
  virtual_text = true,
}

-- Global Keybinds --
vim.keymap.set('n', '<M-n>', '<CMD>cnext<CR>', { desc = 'Quickfix Next' })
vim.keymap.set('n', '<M-p>', '<CMD>cprev<CR>', { desc = 'Quickfix Previous' })

vim.keymap.set('n', '<Esc>', '<CMD>nohlsearch<CR>', { desc = '' })

vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':.lua<CR>')
vim.keymap.set('n', '<leader>X', ':source %<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<M-v>', '<CMD>:vsplit<CR>')
vim.keymap.set('n', '<M-o>', '<CMD>:split<CR>')
vim.keymap.set('n', '√', '<CMD>:split<CR>') -- alt+v but macos is retarded
vim.keymap.set('n', 'ø', '<CMD>:split<CR>') -- alt+v but macos is retarded

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() }) end,
  { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() }) end,
  { desc = 'Go to next [D]iagnostic message' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


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

vim.keymap.set('i', '<C-p>', '<Esc>pa')

-- require all files in <neovim-config-dir>/lua/config
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/config/*.lua', true, true)) do
  local module = file:match('.*/lua/(.-)%.lua$'):gsub('/', '.')
  require(module)
end
