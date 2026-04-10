local util = require('modules.utils')

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
vim.opt.foldenable = true
vim.opt.foldlevelstart = 99
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.winborder = 'rounded'

vim.diagnostic.config {
  virtual_text = true,
}

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


local function map(mode, keybind, action, desc)
  vim.keymap.set(mode, keybind, action, { desc = desc })
end

map('n', '<M-n>', '<CMD>cnext<CR>', 'Quickfix Next')
map('n', '<M-p>', '<CMD>cprev<CR>', 'Quickfix Previous')

map('n', '<Esc>', '<CMD>nohlsearch<CR>', '')

vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':.lua<CR>')
vim.keymap.set('n', '<leader>X', ':source %<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<M-v>', '<CMD>:vsplit<CR>')
vim.keymap.set('n', '<M-o>', '<CMD>:split<CR>')
vim.keymap.set('n', '√', '<CMD>:split<CR>') -- alt+v but macos is retarded
vim.keymap.set('n', 'ø', '<CMD>:split<CR>') -- alt+v but macos is retarded

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

vim.keymap.set('i', '<C-p>', '<Esc>pa')

vim.keymap.set('n', '<leader>ob', function()
  local quiq_directory = require('modules.utils').get_quiq_directory()
  vim.cmd('e ' .. quiq_directory .. 'build.gradle')
end, { desc = '[o]pen [b]uild.gradle' })
vim.keymap.set('n', '<leader>ot', function() vim.cmd('e /Users/jared.weiss/src/todo.md') end, { desc = '[o]pen [t]odo.md' })
vim.keymap.set('n', '<leader>og', function() vim.cmd'e ~/.config/ghostty/config' end, { desc = '[O]pen [g]hostty config'})
vim.keymap.set('n', '<leader>oc', function() vim.cmd "e ~/.config/opencode/opencode.json" end, { desc = 'Open [o]pen[c]ode.json'})
vim.keymap.set('n', '<leader>O', ':Oil<CR>')

vim.keymap.set('n', '<C-f>', 'za', {desc='Toggle the fold under the cursor'})

vim.api.nvim_create_user_command("ToggleTerminal", function()
  if not vim.api.nvim_win_is_valid(M.state.floating_terminal.win) then
    M.state.floating_terminal = get_floating_window({
      buf = M.state.floating_terminal.buf,
    })
    if vim.bo[M.state.floating_terminal.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(M.state.floating_terminal.win)
  end
end, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", "<CMD>ToggleTerminal<CR>", { desc = "[T]oggle floating [T]erminal" })

require('config.lazy')
