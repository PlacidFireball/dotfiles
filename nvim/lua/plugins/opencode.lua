return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  enabled = true,
  config = function()
    local opencode_cmd = 'opencode --port'
    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      interactive = true,
      win = {
        position = 'right',
        enter = true,
        on_win = function(win)
          -- Set up keymaps and cleanup for an arbitrary terminal
          require('opencode.terminal').setup(win.win)
        end,
        width = 0.25,
        height = 0,
        resize = true,
      },
    }

    ---@class OpenCodeContextWithLogs : opencode.Context
    ---@field logs function
    local opencode_context = require("opencode.context")
    function opencode_context:logs()
      return opencode_context.format({path = '/Users/jared.weiss/Dev/quiq/service.log'})
    end

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
        end,
        stop = function()
          require('snacks.terminal').get(opencode_cmd, snacks_terminal_opts):close()
        end,
        toggle = function()
          require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
        end,
      },
      contexts = {
        ---@diagnostic disable-next-line: undefined-field
        ["@logs"] = function (context) return context:logs() end,
      }
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
      { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
      { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<leader>cc", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
      { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
      { desc = "Scroll opencode down" })

    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
