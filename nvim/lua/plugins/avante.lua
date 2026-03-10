---@diagnostic disable: missing-fields
return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  version = false,
  enabled = true,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    debug = false,
    provider = "openai",
    providers = {
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
      ["litellm-claude-4.5"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.claude-4.5-sonnet",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 16384,
          reasoning_effort = "medium",
        }
      },
      ["litellm-gemini-3-flash"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.gemini-3-flash",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 16384,
          reasoning_effort = "medium",
        }
      },
      ["litellm-gemini-3-pro"] = {
        __inherited_from = "openai",
        model = "litellm_manifold_pipeline.gemini-3-pro",
        extra_request_body = {
          temperature = 0.75,
          max_completion_tokens = 16384,
          reasoning_effort = "medium",
        }
      }
    },
    file_selector = {
      provider = "snacks",
    },
    auto_suggestions_provider = nil,
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
    disabled_tools = { "bash" },
    acp_providers = {
      ["opencode"] = {
        command = "opencode",
        args = { "acp" },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
