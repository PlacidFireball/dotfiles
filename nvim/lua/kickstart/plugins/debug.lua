-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
      require('dap.ui.widgets').preview()
    end)
    vim.keymap.set('n', '<leader>df', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set('n', '<leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end)
    
    vim.keymap.set('n', '<F10>', dap.terminate, { desc = 'Terminate the currently running process' })

    vim.keymap.set('n', '<leader>de', function ()
      require("dapui").eval()
    end)
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
        icons = {
          disconnect = '',
          pause = '',
          play = '',
          run_last = '',
          step_back = '',
          step_into = '',
          step_out = '',
          step_over = '',
          terminate = '',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    -- Debug settings if you're using nvim-dap

    dap.configurations.scala = {
      {
        type = 'scala',
        request = 'launch',
        name = 'Run RingMasterApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/ring-master/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51269" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/ring-master/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },{
        type = 'scala',
        request = 'launch',
        name = 'Run RingBearerApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/ring-bearer/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51268" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/ring-bearer/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },{
        type = 'scala',
        request = 'launch',
        name = 'Run MessageImpostorApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/message-impostor/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51266" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/message-impostor/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },{
        type = 'scala',
        request = 'launch',
        name = 'Run MessageManager',
        cwd = "/Users/jared.weiss/Dev/quiq/message-manager/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51265" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/message-manager/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },
      {
        type = 'scala',
        request = 'launch',
        name = 'Run BenderApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/bender/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51268" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/bender/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },
      {
        type = 'scala',
        request = 'launch',
        name = 'Run ConversationManagerApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/conversation-manager/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51267" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/conversation-manager/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },

      {
        type = 'scala',
        request = 'launch',
        name = 'Run EventManagerApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/event-manager/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51264" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/event-manager/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },
      {
        type = 'scala',
        request = 'launch',
        name = 'Run LlmArbiterApplication',
        cwd = "/Users/jared.weiss/Dev/quiq/llm-arbiter/",
        metals = {
          runType = 'run',
          args = { "-tc", "-p", "51263" },
          jvmOptions = { "-Duser.dir=/Users/jared.weiss/Dev/quiq/llm-arbiter/" },
          -- mainClass = "com.centricent.service.RingMasterApplication"
        },
      },
      {
        type = 'scala',
        request = 'launch',
        name = 'Test Target',
        metals = {
          runType = 'testTarget',
        },
      },
    }
    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
