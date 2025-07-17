return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { 'folke/todo-comments.nvim' }, -- NOTE: not really a hard dependency but I need it for some of the keybinds below
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
      picker = {
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
      { "<leader><leader>", function() Snacks.picker.buffers() end,                                                desc = "Buffers" },
      { "<leader>sg",       function() Snacks.picker.grep({ ignored = true }) end,                                 desc = "Grep" },
      { "<leader>g.c",      function() Snacks.picker.grep({ cwd = '/Users/jared.weiss/.centricient' }) end,        desc = "Grep .centricient" },
      { "<leader>sf",       function() Snacks.picker.files({ ignored = true }) end,                                desc = "Find Files" },
      { "<leader>s.c",      function() Snacks.picker.files({ cwd = '/Users/jared.weiss/.centricient' }) end,       desc = "Search .centricient" },
      { "<leader>sp",       function() Snacks.picker.files({ cwd = vim.fn.stdpath('data') }) end,                  desc = "Packages" },
      -- find
      { "<leader>en",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,                desc = "Edit Neovim" },
      { "<leader>sG",       function() Snacks.picker.git_files() end,                                              desc = "Find Git Files" },
      { "<leader>sR",       function() Snacks.picker.recent() end,                                                 desc = "Recent" },
      -- git
      { "<leader>gL",       function() Snacks.picker.git_log() end,                                                desc = "Git Log" },
      { "<leader>gs",       function() Snacks.picker.git_status() end,                                             desc = "Git Status" },
      -- Grep
      { "<leader>/",        function() Snacks.picker.lines() end,                                                  desc = "Buffer Lines" },
      { "<leader>sb",       function() Snacks.picker.grep_buffers() end,                                           desc = "Grep Open Buffers" },
      { "<leader>sw",       function() Snacks.picker.grep_word() end,                                              desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',       function() Snacks.picker.registers() end,                                              desc = "Registers" },
      { "<leader>sa",       function() Snacks.picker.autocmds() end,                                               desc = "Autocmds" },
      { "<leader>sc",       function() Snacks.picker.command_history() end,                                        desc = "Command History" },
      { "<leader>sC",       function() Snacks.picker.commands() end,                                               desc = "Commands" },
      { "<leader>sd",       function() Snacks.picker.diagnostics() end,                                            desc = "Diagnostics" },
      { "<leader>sh",       function() Snacks.picker.help() end,                                                   desc = "Help Pages" },
      { "<leader>sk",       function() Snacks.picker.keymaps() end,                                                desc = "Keymaps" },
      { "<leader>sl",       function() Snacks.picker.loclist() end,                                                desc = "Location List" },
      { "<leader>sr",       function() Snacks.picker.resume() end,                                                 desc = "Resume" },
      -- LSP
      { "gd",               function() Snacks.picker.lsp_definitions() end,                                        desc = "Goto Definition" },
      { "gr",               function() Snacks.picker.lsp_references() end,                                         nowait = true,                     desc = "References" },
      { "gI",               function() Snacks.picker.lsp_implementations() end,                                    desc = "Goto Implementation" },
      { "gT",               function() Snacks.picker.lsp_type_definitions() end,                                   desc = "Goto T[y]pe Definition" },
      { "<leader>ts",       function() Snacks.picker.lsp_symbols() end,                                            desc = "LSP Symbols" },
      { "<leader>st",       function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
      { "<leader>sT",       function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    }
  },
}
