return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      ui.setup()
      require "dap-go".setup()

      ---@diagnostic disable-next-line: missing-fields
      require "nvim-dap-virtual-text".setup {
        enabled = true
      }


      dap.configurations.scala = {
        {
          type = 'scala',
          request = 'launch',
          name = 'Run Scala Project',
          cwd = require("modules.utils").get_quiq_directory,
          metals = function()
            return {
              runType = 'run',
              args = { '-tc', '-p', '51261' },
              jvmOptions = { '-Duser.dir=' .. require("modules.utils").get_quiq_directory() },
            }
          end,
        },
      }

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "Run to Cursor" })

      -- Evaluate the variable under the cursor
      vim.keymap.set("n", "<leader>e?", function()
        ---@diagnostic disable-next-line: missing-fields
        ui.eval(nil, { enter = true })
      end, { desc = "[E]valuate under cursor" })

      vim.keymap.set("n", "<leader>r", dap.run)

      vim.keymap.set("n", "<F1>", dap.continue, { desc = 'Debug Start/Continue' })
      vim.keymap.set("n", "<F2>", ui.toggle, { desc = "Debug UI Toggle" })
      vim.keymap.set("n", "<F7>", function() dap.step_into({ askForTargets = true }) end)
      vim.keymap.set("n", "<F8>", dap.step_over, { desc = 'Debug Step Over' })
      vim.keymap.set("n", "<F9>", dap.step_out, { desc = 'Debug Step Out' })
      vim.keymap.set("n", "<F10>", dap.close, { desc = 'Debug Close' })
      vim.keymap.set("n", "<F12>", dap.restart, { desc = 'Debug Restart' })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end
  }
}
