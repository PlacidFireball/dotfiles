return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local nav = require('nvim-tmux-navigation')

    nav.setup {
      disable_when_zoomed = true,
    }

    vim.keymap.set({ 'n', 't' }, "<C-h>", nav.NvimTmuxNavigateLeft)
    vim.keymap.set({ 'n', 't' }, "<C-j>", nav.NvimTmuxNavigateDown)
    vim.keymap.set({ 'n', 't' }, "<C-k>", nav.NvimTmuxNavigateUp)
    vim.keymap.set({ 'n', 't' }, "<C-l>", nav.NvimTmuxNavigateRight)
  end
}
