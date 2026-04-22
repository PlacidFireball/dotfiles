return {
  {
    'lewis6991/gitsigns.nvim',
    enabled = true,
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged                 = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged_enable          = true,
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        auto_attach                  = true,
        attach_to_untracked          = false,
        -- current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        -- current_line_blame_opts      = {
        --   virt_text = true,
        --   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        --   delay = 1000,
        --   ignore_whitespace = false,
        --   virt_text_priority = 500,
        --   use_focus = true,
        -- },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
    end
  },
  {
    "niuiic/git-log.nvim",
    dependencies = {
      { "niuiic/omega.nvim", build = "cd rs && cargo build --release" }
    },
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>gl', function()
        require('git-log').check_log({
          extra_args = {},
          window_width_ratio = 0.6,
          window_height_ratio = 0.8,
          quiq_key = "q",
        })
      end, { desc = 'foobar' })
    end
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    config = function ()
      require('gitblame').setup({
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%m-%d-%Y %H:%M:%S",
        virtual_text_column = 1,
      })

      vim.keymap.set('n', '<leader>goc', '<CMD>GitBlameOpenCommitURL<CR>', { desc = '[G]it [O]pen [C]ommit' })
    end,
  }
}
