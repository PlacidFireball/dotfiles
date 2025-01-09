return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 2,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "python", "rust", "c", "scala", "java", "lua", "go", "vim", "vimdoc", "markdown", "markdown_inline" },
        sync_install = false,
        auto_install = false,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end
        },
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    priority = 1,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["gj"] = "@function.outer",
              ["]]"] = "@class.outer",
              ["]b"] = "@block.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["gJ"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]B"] = "@block.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["gk"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[b"] = "@block.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["gK"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[B"] = "@block.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["a/"] = "@comment.outer",
              ["i/"] = "@comment.outer",   -- no inner for comment
              ["aa"] = "@parameter.outer", -- parameter -> argument
              ["ia"] = "@parameter.inner",
            },
          },
        },
      }
    end
  }
}
