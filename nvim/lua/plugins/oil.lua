return {
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require 'oil'.setup {
        view_options = {
          show_hidden = true,
        },
        git = {
          add = function()
            return true
          end,
          mv = function()
            return true
          end,
          rm = function()
            return true
          end,
        },
        watch_for_changes = true,
      }

      vim.keymap.set('n', '<M-t>', ":Oil<CR>")
    end
  }
}
