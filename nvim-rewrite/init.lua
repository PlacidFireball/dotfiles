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
vim.opt.foldlevel = 99
vim.opt.foldenable = true
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
vim.keymap.set('n', '<C-f>', 'za', { desc = 'Toggle fold' })

vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':.lua<CR>')
vim.keymap.set('n', '<leader>X', ':source %<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-r>', '<CMD>source $MYVIMRC<CR>', { desc = 'Reload Neovim config' })

vim.keymap.set('n', '<M-v>', '<CMD>:vsplit<CR>')
vim.keymap.set('n', '<M-o>', '<CMD>:split<CR>')
vim.keymap.set('n', '√', '<CMD>:split<CR>') -- alt+v but macos is retarded
vim.keymap.set('n', 'ø', '<CMD>:split<CR>') -- alt+v but macos is retarded

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below split' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above split' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left split' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to below split' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to above split' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right split' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() }) end,
  { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() }) end,
  { desc = 'Go to next [D]iagnostic message' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


vim.keymap.set('n', '=', [[<cmd>vertical resize +5<cr>]])   -- make the window biger vertically
vim.keymap.set('n', '-', [[<cmd>vertical resize -5<cr>]])   -- make the window smaller vertically
vim.keymap.set('n', '+', [[<cmd>horizontal resize +5<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set('n', '_', [[<cmd>horizontal resize -5<cr>]]) -- make the window smaller horizontally by pressing shift and -

vim.keymap.set('i', '<C-p>', '<Esc>pa')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function (ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      vim.system({'cargo', 'build', '--release'}, { cwd = ev.data.path }, function (sys_completed)
        if sys_completed.code == 0 then
          print('successfully installed blink.cmp')
        else
          print('signal' .. sys_completed.signal .. 'stdout:' .. sys_completed.stdout)
        end
      end):wait(60 * 1000)
    end

    if name == 'treesitter' and (kind == 'install' or kind == 'update') then
      vim.cmd('TSUpdate')
      print('successfully installed treesitter')
    end

    if name == 'omega' and (kind == 'install' or kind == 'update') then
      vim.system({'cd', 'rs', '&&', 'cargo', 'build', '--release'}, { cwd = ev.data.path }, function (sys_completed)
        if sys_completed.code == 0 then
          print('successfully installed omega.nvim')
        else
          print('signal' .. sys_completed.signal .. 'stdout:' .. sys_completed.stdout)
        end
      end):wait(60 * 1000)
    end
  end
})

local timer = nil
vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'InsertLeave' }, {
  desc = 'Auto save on buffer changes',
  group = vim.api.nvim_create_augroup('auto-save', { clear = true }),
  callback = function()
    if timer then
      timer:stop()
      timer:close()
    end
    timer = (vim.uv or vim.loop).new_timer()

    if not timer then
      return
    end

    timer:start(250, 0, vim.schedule_wrap(function()
      timer:stop()
      timer:close()
      timer = nil
      if vim.api.nvim_get_current_buf() then -- ensure we have a valid buffer context
        if vim.bo.modified and vim.bo.modifiable and vim.bo.buftype == "" and vim.fn.expand('%') ~= "" then
          vim.cmd('silent! write')
        end
      end
    end))
  end,
})

-- require all files in <neovim-config-dir>/lua/config
for _, file in ipairs(vim.fn.glob(vim.fn.stdpath('config') .. '/lua/config/*.lua', true, true)) do
  local module = file:match('.*/lua/(.-)%.lua$'):gsub('/', '.')
  require(module)
end

vim.notify('neovim config setup', vim.log.levels.INFO)
