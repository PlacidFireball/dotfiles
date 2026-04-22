return {
  {
    'Pocco81/auto-save.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>as', ':ASToggle<CR>', { desc = 'Toggle [A]uto [S]ave' })
      require('auto-save').setup {
        enabled = true,
        trigger_events = { "InsertLeave", "TextChanged" },
        condition = function(buf)
          -- Don't autosave DAP REPL buffers
          if vim.fn.getbufvar(buf, "&filetype") == "dap-repl" then
            return false
          end

          -- NOTE: does not automagically save in .config/nvim (just so we don't make nvim reload all the time)
          if vim.fn.expand("%:p"):find("config/nvim") then
            return false
          end

          if vim.fn.getbufvar(buf, "&modifiable") == 1 then
            return true
          end
          return false
        end,
        debounce_delay = 250,
      }
    end,
  },
}
