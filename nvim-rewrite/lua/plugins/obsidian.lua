return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    require('obsidian').setup {
      workspaces = {
        {
          name = "placidfireball",
          path = "~/Documents/Obsidian/placidfireball/",
        },
      },
      notes_subdir = 'notes',
      completion = {
        blink = true,
        min_chars = 2,
        create_new = false,
      }
    }

    vim.keymap.set('n', '<leader>so', ':ObsidianSearch<CR>', { desc = '[S]earch [O]bsidian'})
    vim.keymap.set('n', '<leader>nt', ':Obsidian tomorrow<CR>', { desc = 'Make [N]ote for [T]omorrow'})
    vim.keymap.set('n', '<leader>ny', ':Obsidian yesterday<CR>', { desc = 'Open [N]ote for [Y]esterday'})
  end,
}
