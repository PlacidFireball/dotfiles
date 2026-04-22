return {
  {
    'folke/todo-comments.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = false },
      dashboard = {
        enabled = true,
        width = 60,
        row = nil,
        col = nil,
        pane_gap = 4,
        preset = {
          pick = nil,
          keys = {
            { icon = " ", key = "f", desc = "Search Files", action = "<leader>sf" },
            { icon = " ", key = "g", desc = "Grep Text", action = "<leader>sg" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = "🛠", key = "M", desc = "Mason", action = ":Mason" },
            { icon = "🛠", key = "O", desc = "Oil", action = ":Oil" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
 ██████╗      ██╗    ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔═══██╗     ██║    ████╗  ██║██║   ██║██║████╗ ████║
██║   ██║     ██║    ██╔██╗ ██║██║   ██║██║██╔████╔██║
██║   ██║██   ██║    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╔╝╚█████╔╝██╗ ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝  ╚════╝ ╚═╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and item.icon == "file" or item.icon == "directory" then
              return Snacks.icon(item.file, item.icon)
            end
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        }
      },
      gitbrowse = {
        enabled = true,
      },
      indent = { enabled = false },
      input = { enabled = false },
      lazygit = {
        enabled = true,
      },
      notifier = {
        enabled = true,
        timeout = 10000,
      },
      picker = { enabled = false, },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = {},
      words = { enabled = true },
      image = {
        enabled = true,
        resolve = function(file, src)
          -- For quiq-wiki files, resolve asset paths relative to the wiki root
          -- since images use paths like "assets/images/foo.png" from the repo root,
          -- not relative to the individual markdown file's directory.
          local wiki_root = vim.fn.expand("~/Dev/quiq/quiq-wiki")
          if file:find(wiki_root, 1, true) and not src:find("^%w%w+://") then
            local candidate = wiki_root .. "/" .. src
            if vim.fn.filereadable(candidate) == 1 then
              return candidate
            end
          end
        end,
        doc = {
          enabled = true,
          inline = true,
          float = false,
          max_width = 80,
          max_height = 40,
        },
      },
    },
    keys = {
      {
        "<leader>lg",
        function()
          if vim.fn.expand("%:p"):match("Dev/quiq/") then
            local current_dir = vim.fn.getcwd()
            local quiq_dir = require("modules.utils").get_quiq_directory()
            vim.cmd('cd ' .. quiq_dir)
            Snacks.lazygit()
            vim.cmd('cd ' .. current_dir)
          else
            Snacks.lazygit()
          end
        end,
        desc = "Lazygit"
      },
      { "<leader>gl", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame line" },
      { "<leader>gb", function() Snacks.gitbrowse() end,      desc = 'Git Browse' },
      {
        "<leader>ts",
        function()
          if Snacks.scroll.enabled then
            Snacks.scroll.disable()
          else
            Snacks.scroll.enable()
          end
        end,
        desc = "[T]oggle [S]croll"
      },
    }
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}
