return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library",    words = { "vim%.uv" } },
            { path = "~/Dev/avante.nvim/lua", words = { "avante" } }
          },
        },
      },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "saghen/blink.cmp" },
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "gopls", "jsonls", "zls", "lexical", "clangd" },
        automatic_installation = true,
      }

      local lspconfig = require "lspconfig"
      local capabilities = require "blink.cmp".get_lsp_capabilities()

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              special = { reload = "require" },
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                vim.fn.expand "data" .. "/lazy/lazy.nvim/lua/lazy",
              }
            }
          }
        }
      }
      lspconfig.rust_analyzer.setup { capabilities = capabilities }
      lspconfig.pyright.setup {
        root_dir = function(fname)
          return vim.fn.getcwd()
        end,
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = '/Users/jared.weiss/miniconda3/bin/python'
          }
        }
      }
      lspconfig.gopls.setup { capabilities = capabilities }
      lspconfig.ts_ls.setup { capabilities = capabilities }
      lspconfig.jsonls.setup { capabilities = capabilities }
      lspconfig.zls.setup { capabilities = capabilities }
      lspconfig.lexical.setup {
        cmd = { "/home/placidfireball/build/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
        root_dir = function(fname)
          return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
        end,
        filetypes = { "elixir", "eelixir", "heex" },
        capabilities = capabilities,
      }
      lspconfig.clangd.setup { capabilities = capabilities }

      -- scala comes from nvim-metals

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if not client then return end

          local map = function(keys, func, desc)
            ---@diagnostic disable-next-line: missing-fields
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- require('lsp_signature').on_attach({
          --   bind = true,
          --   handler_opts = {},
          -- }, bufnr)
          --
          -- vim.keymap.set({ 'n' }, '<C-s>', function()
          --   require('lsp_signature').toggle_float_win()
          -- end, { silent = true, noremap = true, desc = 'Toggle Signature' })

          vim.keymap.set({ 'n' }, '<leader>k', function()
            vim.lsp.buf.signature_help()
          end, { silent = true, noremap = true, desc = 'toggle signature' })

          local formatting_enabled_filetypes = { "lua", "json", "rust", "zig" }

          local function has_value(table, value)
            for _, val in ipairs(table) do
              if value == val then
                return true
              end
            end
            return false
          end

          if has_value(formatting_enabled_filetypes, vim.bo.filetype) and client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = event.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
              end
            })
          end

          if client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end
      })
    end
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      'saghen/blink.cmp'
    },
    ft = { "scala", "sbt", "java" },
    keys = {},
    init = function()
      local metals_config = require("metals").bare_config()
      require("metals").setup_dap()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }

      local function get_operating_system()
        if jit then
          return jit.os
        end

        local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))

        if fh then
          return fh:read()
        else
          return 'Windows'
        end
      end

      local os = get_operating_system()

      if os == 'Darwin' or os == 'OSX' then
        metals_config.settings.gradleScript = '/opt/gradle/gradle-8.4/bin/gradle'
        metals_config.settings.javaHome = '/Library/Java/JavaVirtualMachines/liberica-jdk-17.jdk/Contents/Home'
        metals_config.settings.scalafixConfigPath = '/Users/jared.weiss/build/dotfiles/.scalafix.conf'
      end

      metals_config.init_options.statusBarProvider = 'on'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup('nvim-metals', { clear = true }),
      })
    end,
  }

}
