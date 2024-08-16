-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
  },
  { 'famiu/bufdelete.nvim' },
  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt', 'java' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>cW", function() require('metals').hover_worksheet() end,               desc = "Metals Worksheet" },
      { "<leader>cM", function() require('telescope').extensions.metals.commands() end, desc = "Telescope Metals Commands" },
    },
    init = function()
      local metals_config = require('metals').bare_config()
      require('metals').setup_dap()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }

      local function get_operating_system()
        if jit then
          return jit.os
        end

        local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))

        if fh then
          return fh:read()
        else
          return 'Windows'
        end
      end

      local operating_system = get_operating_system()

      if operating_system == 'Darwin' or operating_system == 'OSX' then
        -- print('Setting gradleScript/javaHome.')
        -- print(operating_system)
        metals_config.settings.gradleScript = '/opt/gradle/gradle-8.0.2/bin/gradle'
        metals_config.settings.javaHome = '/Library/Java/JavaVirtualMachines/liberica-jdk-17.jdk/Contents/Home'
      else
        print 'This is not an apple system. Not setting up gradle/java home'
        -- print(operating_system)
      end

      metals_config.init_options.statusBarProvider = 'on'
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    after = 'nvim-treesitter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('treesitter-context').setup {
        enable = false,
      }

      -- vim.keymap.set('n', '<leader>gtc', function()
      --   require('treesitter-context').go_to_context(vim.v.count1)
      -- end, { desc = "[G]o [T]o [C]ontext", silent = true })
    end,
  },
  {
    'desdic/agrolens.nvim',
    after = 'nvim-treesitter',
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        group_empty_dirs = true,
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        disable_when_zoomed = true,
        keybindings = {
          left = '<C-h>',
          down = '<C-j>',
          up = '<C-k>',
          right = '<C-l>',
          last_active = '<C-\\>',
          next = '<C-Space>',
        },
      }
    end,
  },
  {
    'Pocco81/auto-save.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>as', ':ASToggle<CR>', { desc = 'Toggle [A]uto [S]ave' })
      require('auto-save').setup {}
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'gregorias/coerce.nvim',
    tag = 'v2.1',
    config = true,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },
  -- {
  --   'startup-nvim/startup.nvim',
  --   requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('startup').setup {
  --       section_1 = {
  --         type = 'text',
  --         align = 'center',
  --         fold_section = false,
  --         title = 'Main',
  --         default_color = '#0000FF',
  --         content = {
  --           '      ___           ___           ___                                    ___     ',
  --           '     /__/\\         /  /\\         /  /\\          ___        ___          /__/\\    ',
  --           '     \\  \\:\\       /  /:/_       /  /::\\        /__/\\      /  /\\        |  |::\\   ',
  --           '      \\  \\:\\     /  /:/ /\\     /  /:/\\:\\       \\  \\:\\    /  /:/        |  |:|:\\  ',
  --           '  _____\\__\\:\\   /  /:/ /:/_   /  /:/  \\:\\       \\  \\:\\  /__/::\\      __|__|:|\\:\\ ',
  --           ' /__/::::::::\\ /__/:/ /:/ /\\ /__/:/ \\__\\:\\  ___  \\__\\:\\ \\__\\/\\:\\__  /__/::::| \\:\\',
  --           ' \\  \\:\\~~\\~~\\/ \\  \\:\\/:/ /:/ \\  \\:\\ /  /:/ /__/\\ |  |:|    \\  \\:\\/\\ \\  \\:\\~~\\__\\/',
  --           '  \\  \\:\\  ~~~   \\  \\::/ /:/   \\  \\:\\  /:/  \\  \\:\\|  |:|     \\__\\::/  \\  \\:\\      ',
  --           '   \\  \\:\\        \\  \\:\\/:/     \\  \\:\\/:/    \\  \\:\\__|:|     /__/:/    \\  \\:\\     ',
  --           '    \\  \\:\\        \\  \\::/       \\  \\::/      \\__\\::::/      \\__\\/      \\  \\:\\    ',
  --           '     \\__\\/         \\__\\/         \\__\\/           ~~~~                   \\__\\/    ',
  --         },
  --       },
  --       section_2 = {
  --         type = "mapping",
  --         align  = "center",
  --         fold_section = false,
  --         title = "Commands",
  --         content = {
  --           { 'Find Files', 'Telescope find_files', '<leader>sf' },
  --           { 'Live Grep', 'Telesocpe live_grep', '<leader>sg' },
  --         }
  --       },
  --       options = {
  --         mapping_keys = true,
  --         empty_lines_between_mappings = true,
  --         disable_statuslines = true,
  --         paddings = { 1, 2 },
  --       },
  --       mappings = {
  --         execute_command = '<CR>',
  --         open_file = 'o',
  --         open_file_split = '<C-o>',
  --         open_section = '<TAB>',
  --         open_help = '?',
  --       },
  --       parts = { 'section_1', 'section_2' },
  --     }

  --     require('startup').create_mappings {
  --       ['<leader>sf']='<cmd>Telescope find_files<CR>',
  --       ['<leader>sg']='<cmd>Telescope live_grep<CR>',
  --     }
  --   end,
  -- },
}
