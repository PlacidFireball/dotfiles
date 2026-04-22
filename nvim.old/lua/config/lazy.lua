-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before (set in options.lua)
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    {
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
    },
    { import = "plugins" },
  },
})
