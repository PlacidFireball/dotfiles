return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-tree/nvim-web-devicons',              enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            theme = "ivy"
          },
          extensions = {
            fzf = {}
          }
        }
      }

      local function map(mode, keybind, action, desc)
        vim.keymap.set(mode, keybind, action, { desc = desc })
      end

      require('telescope').load_extension('fzf')

      map('n', '<leader>sf', require('telescope.builtin').find_files, '[S]earch [F]iles')
      map('n', '<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
      map('n', '<leader>so', require('telescope.builtin').oldfiles, '[S]earch [O]ldfiles')
      map('n', '<leader>sc', require('telescope.builtin').commands, '[S]earch [C]ommands')
      map('n', '<leader>sr', require('telescope.builtin').resume, '[S]earch [R]esume')
      -- NOTE: you can filter the type of node to show by doing :var: for example :function: is also good
      map('n', '<leader>st', require('telescope.builtin').treesitter, '[S]earch [T]reesitter')
      map('n', '<leader><leader>', require('telescope.builtin').buffers, '[S]earch Existing Buffers')

      vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>en', function()
        local opts = require 'telescope.themes'.get_ivy({
          cwd = vim.fn.stdpath('config')
        })
        require('telescope.builtin').find_files(opts)
      end, { desc = '[E]dit [N]eovim' })

      vim.keymap.set('n', '<leader>gn', function()
        local opts = require 'telescope.themes'.get_ivy({
          cwd = vim.fn.stdpath('config')
        })
        require('telescope.builtin').live_grep(opts)
      end, { desc = '[G]rep [N]eovim' })

      vim.keymap.set('n', '<leader>sp', function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), "lazy")
        }
      end, { desc = '[S]earch [P]ackages' })

      -- Shortcut for searching .centricient
      vim.keymap.set('n', '<leader>s.c', function()
        require('telescope.builtin').find_files { cwd = '/Users/jared.weiss/.centricient/' }
      end, { desc = 'search .centricient' })

      -- <leader>sg [S]earch with [G]rep
      require('modules.telescope.multigrep').setup()
    end
  }
}
