return {
  'junegunn/vim-easy-align',
  config = function()
    vim.keymap.set('v', '<C-A>', '<cmd>EasyAlign /=/<CR>')
  end
}
