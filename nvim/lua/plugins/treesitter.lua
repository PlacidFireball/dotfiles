return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local treesitter = require('nvim-treesitter')

      local installed_parsers = { "python", "rust", "c", "scala", "java", "lua", "go", "vim", "vimdoc", "markdown", "markdown_inline", "elixir" }

      treesitter.setup {}
      treesitter.install(installed_parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = installed_parsers,
        callback = function(ev)
          local max_filesize = 150 * 1024 -- 150 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end

          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'

          vim.treesitter.start()
        end
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    branch = "main",
    config = function()
      ---@diagnostic disable-next-line: missing-fields

      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        }
      }

      -- move keybinds --
      -- goto next start --
      local move = require('nvim-treesitter-textobjects.move')
      local default_modes = {'n', 'x', 'o'}
      vim.keymap.set(default_modes, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set(default_modes, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
      vim.keymap.set(default_modes, "]b", function() move.goto_next_start("@block.outer", "textobjects") end)
      vim.keymap.set(default_modes, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end)

      -- goto next end --
      vim.keymap.set(default_modes, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set(default_modes, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
      vim.keymap.set(default_modes, "]B", function() move.goto_next_end("@block.outer", "textobjects") end)
      vim.keymap.set(default_modes, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end)

      -- goto previous start --
      vim.keymap.set(default_modes, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[b", function() move.goto_previous_start("@block.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end)

      -- goto previous end --
      vim.keymap.set(default_modes, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[B", function() move.goto_previous_end("@block.outer", "textobjects") end)
      vim.keymap.set(default_modes, "[A", function() move.goto_previous_end("@parameter.inner", "textobjects") end)

      -- select keybinds --
      default_modes = {'x', 'o'}
      local select = require('nvim-treesitter-textobjects.select')
      vim.keymap.set(default_modes, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set(default_modes, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set(default_modes, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set(default_modes, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
      vim.keymap.set(default_modes, "ab", function() select.select_textobject("@block.outer", "textobjects") end)
      vim.keymap.set(default_modes, "ib", function() select.select_textobject("@block.inner", "textobjects") end)
      vim.keymap.set(default_modes, "al", function() select.select_textobject("@loop.outer", "textobjects") end)
      vim.keymap.set(default_modes, "il", function() select.select_textobject("@loop.inner", "textobjects") end)
      vim.keymap.set(default_modes, "a/", function() select.select_textobject("@comment.outer", "textobjects") end)
      vim.keymap.set(default_modes, "i/", function() select.select_textobject("@comment.outer", "textobjects") end)
      vim.keymap.set(default_modes, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end)
      vim.keymap.set(default_modes, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end)
    end
  }
}
