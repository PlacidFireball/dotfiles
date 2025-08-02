---@diagnostic disable: missing-fields
return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  enabled = function()
    -- Only enable this plugin on work laptop
    return vim.uv.os_uname().sysname == 'Darwin' and vim.uv.os_gethostname() == 'Jareds-Macbook-Pro.local'
  end,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    debug = false,
    provider = "openai",
    providers = {
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o",
      --   timeout = 30000,         -- Timeout in milliseconds, increase this for reasoning models
      --   context_window = 128000, -- Number of tokens to send to the model for context
      --   extra_request_body = {
      --     temperature = 0.75,
      --     max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
      --     reasoning_effort = "medium",   -- low|medium|high, only used for reasoning models
      --   },
      -- },
      openai = {
        endpoint = "https://quiqgpt-api.quiq.sh/openai",
        model = "litellm_manifold_pipeline.gpt-4o",
        timeout = 60000,
        context_window = 64000,
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 8192,
          reasoning_effort = "medium",
          stream_options = nil,
        },
        extra_headers = {
        }
      },
      ["litellm-gemini"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.gemini-2.5-flash",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 16384,
          reasoning_effort = "medium",
          system = "This is the system message for prompts.", -- Added system message
        },
      },
      ["litellm-claude"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.claude-4-sonnet",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 16384,
          reasoning_effort = "medium",
        },
      }
    },
    selector = {
      provider = "snacks",
    },
    behaviour = {
      use_cwd_as_project_root = true,
    },
    rules = {
    },
    repo_map = {
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua",            -- for file_selector provider fzf
    "folke/snacks.nvim",           -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
