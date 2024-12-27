return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "famiu/bufdelete.nvim",
    },
    config = function()
      require "bufferline".setup {
        options = {
          diagnostics = "nvim_lsp",
          --- count is an integer representing total count of errors
          --- level is a string "error" | "warning"
          --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
          --- this should return a string
          --- Don't get too fancy as this function will be executed a lot
          diagnostics_indicator = function(count, level, _, _)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
        },
      }

      local map = vim.keymap.set

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
      map('n', '<M-J>', '<cmd>BufferLineMovePrev<CR>')  -- Alt+Shift+j grab to with you to left
      map('n', '<M-K>', '<cmd>BufferLineMoveNext<CR>')  -- Alt+Shift+k grab to with you to right
    end,
  }
}
