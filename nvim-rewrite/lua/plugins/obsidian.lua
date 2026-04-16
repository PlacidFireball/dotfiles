return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    require('obsidian').setup {
      legacy_commands = false,
      ---@diagnostic disable-next-line: missing-fields
      ui = { enable = false },
      workspaces = {
        {
          name = "placidfireball",
          path = "~/Documents/Obsidian/placidfireball/",
        },
        {
          name = 'quiq-wiki',
          path = '~/Dev/quiq/quiq-wiki/'
        }
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
        order = { ' ', 'x' },
      },
      note_id_func = function (title, _)
        -- TODO: this likely won't work if I wanna stick the note in a specific folder... maybe ustilize path?
        return title
      end,
      statusline = { enabled = false },
      frontmatter = {
        enabled = false,
        func = function (note)
          if vim.fn.mode():sub(1, 1) == 'i' then return {} end -- Don't format this shit in insert mode
          return require('obsidian.builtin').frontmatter(note)
        end,
        sort = { 'id', 'aliases', 'tags' }
      }
    }

    vim.keymap.set('n', '<leader>so', ':Obsidian search<CR>', { desc = '[S]earch [O]bsidian'})
    vim.keymap.set('n', '<leader>nf', ':Obsidian quick_switch<CR>', { desc = '[S]earch Obsidian [F]iles'})
    vim.keymap.set('n', '<leader>nT', ':Obsidian tomorrow<CR>', { desc = 'Make [N]ote for [T]omorrow'})
    vim.keymap.set('n', '<leader>nt', ':Obsidian today<CR>', { desc = 'Make [N]ote for [T]omorrow'})
    vim.keymap.set('n', '<leader>ny', ':Obsidian yesterday<CR>', { desc = 'Open [N]ote for [Y]esterday'})
    vim.keymap.set('n', '<leader>nn', ':Obsidian new<CR>', { desc = 'Open [N]ew [N]ote'})
    vim.keymap.set('n', '<leader>nw', ':Obsidian workspace<CR>', { desc = 'Open [N]otes [W]orkspace' })
  end,
}
