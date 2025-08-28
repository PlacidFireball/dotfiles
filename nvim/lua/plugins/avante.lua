---@diagnostic disable: missing-fields
return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  enabled = true,
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
        model = "litellm_manifold_pipeline.gpt-5",
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
        },
      },
      ["litellm-gemini-flash-lite"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.gemini-2.5-flash-lite",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 2048,
          reasoning_effort = "low",
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
    file_selector = {
      provider = "snacks",
    },
    auto_suggestions_provider = "litellm-gemini-flash-lite",
    suggestion = {
      debounce = 600,
      throttle = 600
    },
    selector = {
      provider = "snacks",
    },
    selection = {
      hint_desplay = "none"
    },
    behaviour = {
      auto_suggestions = false,
      use_cwd_as_project_root = true,
    },
    rules = {
    },
    repo_map = {
    },
    disabled_tools = { "bash" },
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
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
