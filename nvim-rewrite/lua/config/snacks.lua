local h = require('config.helpers')

vim.pack.add(h.spec('folke/todo-comments.nvim', 'todo-comments'), h.po())
vim.pack.add(h.spec('folke/snacks.nvim', 'snacks'), h.po())

require('snacks').setup {
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
        { icon = "🛠", key = "M", desc = "Mason", action = ":Mason" },
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
    }
  },
  gitbrowse = {
    enabled = true,
  },
  indent = { enabled = false },
  input = { enabled = true },
  lazygit = {
    enabled = true,
  },
  notifier = {
    enabled = true,
    timeout = 10000,
  },
  picker = {
    on_show = function(picker)
      vim.schedule(function()
        vim.cmd("startinsert")
      end)
    end,
    actions = {
      opencode_send = function(picker)
        local selected = picker:selected({ fallback = true })
        if selected and #selected > 0 then
          local files = {}
          for _, item in ipairs(selected) do
            if item.file then
              table.insert(files, item.file)
            end
          end
          picker:close()

          require("opencode.core").open({
            new_session = false,
            focus = "input",
            start_insert = true,
          })

          local context = require("opencode.context")
          for _, file in ipairs(files) do
            context.add_file(file)
          end
        end
      end,
    },
    win = {
      input = {
        keys = {
          -- Use <localleader>o or any preferred key to send files to opencode
          ["<C-o>"] = { "opencode_send", mode = { "n", "i" } },
        },
      },
    },
  },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = {},
  words = { enabled = true },
  which_key = { enabled = true },
}

local default_picker_params = {
  ignored = true,
  exclude = { "*.class", "*.mdx", "*.log" }
}

vim.keymap.set("n", "<leader>lg", function()
  if vim.fn.expand("%:p"):match("Dev/quiq/") then
    local current_dir = vim.fn.getcwd()
    local quiq_dir = require("modules.utils").get_quiq_directory()
    vim.cmd('cd ' .. quiq_dir)
    Snacks.lazygit()
    vim.cmd('cd ' .. current_dir)
  else
    Snacks.lazygit()
  end
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl",       function() Snacks.git.blame_line() end, { desc = "[G]it [B]lame line" })
vim.keymap.set("n", "<leader>gb",       function() Snacks.gitbrowse() end, { desc = 'Git Browse' })
vim.keymap.set("n", "<leader>ts",       function() if Snacks.scroll.enabled then Snacks.scroll.disable() else Snacks.scroll.enable() end end, { desc = 'Git Browse' })
vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sg",       function() Snacks.picker.grep(default_picker_params) end, { desc = "Grep" })
vim.keymap.set("n", "<leader>g.c",      function() Snacks.picker.grep({ cwd = '/Users/jared.weiss/.centricient' }) end, { desc = "Grep .centricient" })
vim.keymap.set("n", "<leader>sf",       function() Snacks.picker.files(default_picker_params) end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>s.c",      function() Snacks.picker.files({ cwd = '/Users/jared.weiss/.centricient' }) end, { desc = "Search .centricient" })
vim.keymap.set("n", "<leader>sp",       function() Snacks.picker.files({ cwd = vim.fn.stdpath('data') }) end, { desc = "Packages" })
vim.keymap.set("n", "<leader>gp",       function() Snacks.picker.grep({ cwd = vim.fn.stdpath('data') }) end, { desc = "Grep Packages" })
vim.keymap.set("n", "<leader>gn",       function() Snacks.picker.grep({ cwd = vim.fn.stdpath('config') }) end, { desc = "Grep Neovim" })
-- find
vim.keymap.set("n", "<leader>en",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Edit Neovim" })
vim.keymap.set("n", "<leader>sR",       function() Snacks.picker.recent() end, { desc = "Recent" })
-- Grep
vim.keymap.set("n", "<leader>/",        function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sb",       function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set({"n","x"}, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
-- search
vim.keymap.set("n", "<leader>'",        function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa",       function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sc",       function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC",       function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd",       function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sh",       function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sk",       function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl",       function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sr",       function() Snacks.picker.resume() end, { desc = "Resume" })
-- LSP
vim.keymap.set("n", "gd",               function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gr",               function() Snacks.picker.lsp_references() end, { desc = "References" })
vim.keymap.set("n", "gI",               function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gT",               function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai",              function() Snacks.picker.lsp_incoming_calls() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gao",              function() Snacks.picker.lsp_outgoing_calls() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>st",       function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
-- Undo
vim.keymap.set("n", "<leader>u",        function() Snacks.picker.undo() end, { desc = ""})
vim.keymap.set("n", "<leader>oc",       function() vim.cmd "e ~/.config/opencode/opencode.json" end, { desc = "Open opencode.json" })
