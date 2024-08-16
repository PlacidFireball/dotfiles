local map = vim.keymap.set

-- Tabline binds
map('n', '<C-q>', function()
  require('bufdelete').bufdelete(0, true)
end) -- shift+Quit to close current tab
map('n', 'g1', function()
  require('bufferline').go_to(1, true)
end)
map('n', 'g2', function()
  require('bufferline').go_to(2, true)
end)
map('n', 'g3', function()
  require('bufferline').go_to(3, true)
end)
map('n', 'g4', function()
  require('bufferline').go_to(4, true)
end)
map('n', 'g5', function()
  require('bufferline').go_to(5, true)
end)
map('n', 'g6', function()
  require('bufferline').go_to(6, true)
end)
map('n', 'g7', function()
  require('bufferline').go_to(7, true)
end)
map('n', 'g8', function()
  require('bufferline').go_to(8, true)
end)
map('n', 'g9', function()
  require('bufferline').go_to(9, true)
end)
map('n', 'g0', function()
  require('bufferline').go_to(10, true)
end)
map('n', '<M-j>', '<cmd>BufferLineCyclePrev<CR>') -- Alt+j to move to left
map('n', '<M-k>', '<cmd>BufferLineCycleNext<CR>') -- Alt+k to move to right
map('n', '<M-J>', '<cmd>BufferLineMovePrev<CR>') -- Alt+Shift+j grab to with you to left
map('n', '<M-K>', '<cmd>BufferLineMoveNext<CR>') -- Alt+Shift+k grab to with you to right

-- MacOS iTerm keybinds
map('n', '∆', '<cmd>BufferLineCyclePrev<CR>') -- Alt+j to move to left
map('n', '˚', '<cmd>BufferLineCycleNext<CR>') -- Alt+k to move to right
map('n', 'Ô', '<cmd>BufferLineMovePrev<CR>') -- Alt+Shift+j grab to with you to left
map('n', '', '<cmd>BufferLineMoveNext<CR>') -- Alt+Shift+k grab to with you to right

map('n', '<M-v>', '<cmd>vsplit<cr>')
map('n', '<M-o>', '<cmd>split<cr>')

-- MacOS iTerm keybinds
map('n', '√', '<cmd>vsplit<cr>')
map('n', 'ø', '<cmd>split<cr>')

map('n', '<M-q>', '<cmd>q<cr>')

map('n', '∂ç', '<cmd>DistantConnect ssh://dev1 options="ssh.backend=libssh,ssh.verbose=true"<CR>')
map('n', '<M-d><M-c>', '<cmd>DistantConnect ssh://dev1 options="ssh.backend=libssh,ssh.verbose=true"<CR>')

return {}
