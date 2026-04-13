return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    require('obsidian').setup {
      legacy_commands = false,
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
      },
      checkbox = {
        enabled = true,
        create_new = true,
        order = { ' ', '~', 'x' }
      },
      note_id_func = function (title, _)
        -- TODO: this likely won't work if I wanna stick the note in a specific folder... maybe ustilize path?
        return title
      end
    }

    vim.keymap.set('n', '<leader>so', ':ObsidianSearch<CR>', { desc = '[S]earch [O]bsidian'})
    vim.keymap.set('n', '<leader>nt', ':Obsidian tomorrow<CR>', { desc = 'Make [N]ote for [T]omorrow'})
    vim.keymap.set('n', '<leader>ny', ':Obsidian yesterday<CR>', { desc = 'Open [N]ote for [Y]esterday'})
    vim.keymap.set('n', '<leader>nn', ':Obsidian new<CR>', { desc = 'Open [N]ew [N]ote'})
  end,
}
