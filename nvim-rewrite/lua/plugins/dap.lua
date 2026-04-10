---@diagnostic disable: missing-fields
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim"
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      ui.setup {
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        floating = {
          border = "rounded",
          mappings = {
            ["close"] = { "q", "<Esc>" },
          },
        },
      }
      vim.keymap.set("n", "<leader>oB", function ()
        ui.float_element("breakpoints", { enter = true })
      end)

      require("mason-nvim-dap").setup {
        ensure_installed = {
          "codelldb",
          "cpptools",
        }
      }

      require "dap-go".setup()

      ---@diagnostic disable-next-line: missing-fields
      require "nvim-dap-virtual-text".setup {
        enabled = true
      }

      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/codelldb",
        name = "lldb",
      }


      dap.configurations.scala = {
        {
          type = 'scala',
          request = 'launch',
          name = 'Run Scala Project',
          cwd = require("modules.utils").get_quiq_directory,
          metals = function()
            local quiq_directory = require("modules.utils").get_quiq_directory()

            local scala_args = {}

            if quiq_directory:find("ring-bearer", 0, true) then
              scala_args = { '-t', '-p', '51262' }
            else
              scala_args = { '-tc', '-p', '51261' }
            end


            return {
              runType = 'run',
              args = scala_args,
              jvmOptions = { '-Duser.dir=' .. quiq_directory },
            }
          end,
        },
      }

      dap.configurations.rust = {
        {
          name = "Run Rust Project",
          request = "launch",
          type = "lldb",
          program = function()
            return vim.fn.getcwd() .. "/target/debug/white-lang-rust-v2"
          end,
          args = { "simulate", "scratch/foo.w" },
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        }
      }

      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })

      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "Run to Cursor" })

      -- Evaluate the variable under the cursor
      vim.keymap.set("n", "<leader>e?", function()
        ---@diagnostic disable-next-line: missing-fields
        ui.eval(nil, { enter = true })
      end, { desc = "[E]valuate under cursor" })

      vim.keymap.set("n", "<F1>", dap.continue, { desc = 'Contiue/Start' })
      vim.keymap.set("n", "<F2>", ui.toggle, { desc = "Debug UI Toggle" })
      vim.keymap.set("n", "<F7>", function() dap.step_into({ askForTargets = true }) end)
      vim.keymap.set("n", "<F8>", dap.step_over, { desc = 'Debug Step Over' })
      vim.keymap.set("n", "<F9>", dap.step_out, { desc = 'Debug Step Out' })
      vim.keymap.set("n", "<F10>", dap.terminate, { desc = 'Debug Terminate' })

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
