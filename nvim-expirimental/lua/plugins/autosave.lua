return {
  {
    'Pocco81/auto-save.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>as', ':ASToggle<CR>', { desc = 'Toggle [A]uto [S]ave' })
      require('auto-save').setup {
        enabled = true,
        trigger_events = { "InsertLeave" },
        condition = function(buf)
          -- NOTE: does not automagically save in .config/nvim (just so we don't make nvim reload all the time)
          if vim.fn.expand("%:p"):find("config/nvim") then
            return false
          end
          if vim.fn.getbufvar(buf, "&modifiable") == 1 then
            return true
          end
          return false
        end,
        debounce_delay = 100,
      }
    end,
  },
}
