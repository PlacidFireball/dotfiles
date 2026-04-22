return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    enabled = false,
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

      vim.keymap.set('n', '<C-q>', function() require('bufdelete').bufdelete(0, true) end)
      vim.keymap.set('n', '<M-j>', '<cmd>BufferLineCyclePrev<CR>') -- Alt+j to move to left
      vim.keymap.set('n', '<M-k>', '<cmd>BufferLineCycleNext<CR>') -- Alt+k to move to right
      vim.keymap.set('n', '<M-J>', '<cmd>BufferLineMovePrev<CR>')  -- Alt+Shift+j grab to with you to left
      vim.keymap.set('n', '<M-K>', '<cmd>BufferLineMoveNext<CR>')  -- Alt+Shift+k grab to with you to right
    end,
  }
}
