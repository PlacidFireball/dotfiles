return {
  {
    'nvim-telescope/telescope.nvim',
    version = "*",
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-tree/nvim-web-devicons',              enabled = vim.g.have_nerd_font },
      'BurntSushi/ripgrep',
      'sharkdp/fd',
    },
    config = function()
      require('telescope').setup {
        pickers = {
          extensions = {
            fzf = {}
          }
        }
      }

      local function map(mode, keybind, action, desc)
        vim.keymap.set(mode, keybind, action, { desc = desc })
      end

      require('telescope').load_extension('fzf')
      local builtin = require('telescope.builtin')

      map('n', '<leader>sf', builtin.find_files, '[S]earch [F]iles')
      map('n', '<leader>sh', builtin.help_tags, '[S]earch [H]elp')
      map('n', '<leader>so', builtin.oldfiles, '[S]earch [O]ldfiles')
      map('n', '<leader>sc', builtin.command_history, '[S]earch [C]ommand History')
      map('n', '<leader>sr', builtin.resume, '[S]earch [R]esume')
      map('n', '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps')
      map('n', '<leader>sb', builtin.builtin, '[S]earch [B]uiltin Pickers')
      -- NOTE: you can filter the type of node to show by doing :var: for example :function: is also good
      map('n', '<leader>st', builtin.treesitter, '[S]earch [T]reesitter')
      map('n', '<leader><leader>', builtin.buffers, '[S]earch Existing Buffers')

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>en', function()
        local opts = require 'telescope.themes'.get_ivy({
          cwd = vim.fn.stdpath('config')
        })
        builtin.find_files(opts)
      end, { desc = '[E]dit [N]eovim' })

      vim.keymap.set('n', '<leader>sp', function()
        builtin.find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), "lazy")
        }
      end, { desc = '[S]earch [P]ackages' })

      -- Shortcut for searching .centricient
      vim.keymap.set('n', '<leader>s.c', function()
        builtin.find_files { cwd = '/Users/jared.weiss/.centricient/' }
      end, { desc = 'search .centricient' })

      -- <leader>sg [S]earch with [G]rep
      require('modules.telescope.multigrep').setup()

      -- <leader>sq [S]earch [Q]dev commands
      require('modules.telescope.qdev').setup()

      -- <leader>tv/tc/to/tt [T]reesitter [V]ariables, [C]lasses, [O]bjects, [T]raits
      require('modules.telescope.tree-sitter-picker').setup()
    end
  }
}
