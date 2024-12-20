return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
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
            { icon = "🛠", key = "M", desc = "Mason", action = ":Mason", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
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
      git = { enabled = true },
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
      quickfile = { enabled = false },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
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
  }
}
