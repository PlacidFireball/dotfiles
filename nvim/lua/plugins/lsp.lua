return {
  {
    "mason-org/mason-lspconfig.nvim",
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
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
      { "saghen/blink.cmp" },
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "gopls", "jsonls", "zls", "lexical", "clangd", "ts_ls" },
        automatic_installation = true,
        automatic_enable = true,
      }

      local capabilities = require "blink.cmp".get_lsp_capabilities()

      vim.lsp.config("lua_ls", {
        cmd = { 'lua-language-server' },
        filetypes = {'lua'},
        root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
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
      })

      vim.lsp.config('rust_analyzer', { capabilities = capabilities })

      vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        -- root_dir = function(fname)
        --   return vim.fn.getcwd()
        -- end,
        filetypes = {'python'},
        root_markers =   { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
            pythonPath = '/Users/jared.weiss/miniconda3/bin/python'
          }
        }
      })

      vim.lsp.config('clangd', {
        capabilities = capabilities,
        cmd = {
          'clangd',
          '--query-driver=/usr/bin/cc,/usr/bin/clang,/usr/bin/clang++,/opt/homebrew/bin/gcc*,/opt/homebrew/bin/g++*',
          '--fallback-style=llvm',
        },
        init_options = {
          fallbackFlags = {
            '-I/opt/homebrew/include',
            '-I/opt/homebrew/opt/libre/include/re',
            '-I/opt/homebrew/opt/baresip/include',
            '-I/opt/homebrew/opt/openssl@3/include',
            '-I/opt/homebrew/opt/opus/include',
          },
        },
      })

      vim.lsp.config("gradle_ls", {
        settings = {
          gradleWrapperEnabled = true,
        },
        capabilities = capabilities
      })

      vim.lsp.config('gopls', { capabilities = capabilities })

      vim.lsp.config('ts_ls', { capabilities = capabilities })

      vim.lsp.config('jsonls', { capabilities = capabilities })

      vim.lsp.config('zls', { capabilities = capabilities })


      -- ponytail: deps that are copied into node_modules rather than symlinked
      -- (git deps, packed file: deps) make LSP jumps land on a read-only
      -- duplicate. Resolve the owning checkout by walking up from node_modules
      -- and confirming package.json name, then rewrite the location.
      -- Ceiling: matches by package name, not version. If the checkout has
      -- drifted off the installed version you land on the newer file.
      local redirect_clients = { ts_ls = true, vtsls = true, eslint = true }

      local redirect_methods = {
        ['textDocument/definition'] = true,
        ['textDocument/typeDefinition'] = true,
        ['textDocument/implementation'] = true,
        ['textDocument/declaration'] = true,
        ['textDocument/references'] = true,
      }

      local pkg_dir_cache = {}

      local function name_matches(dir, pkg)
        local f = io.open(dir .. '/package.json')
        if not f then return false end
        local text = f:read(4096) or ''
        f:close()
        return text:match('"name"%s*:%s*"([^"]+)"') == pkg
      end

      -- Walk up from the node_modules dir looking for the real checkout, both as
      -- a direct child (sibling repos) and one level down (packages/, apps/).
      local function find_pkg_dir(nm_dir, pkg)
        local key = nm_dir .. '\0' .. pkg
        local cached = pkg_dir_cache[key]
        if cached ~= nil then return cached or nil end

        local found = false
        local dir = nm_dir
        for _ = 1, 5 do
          dir = vim.fs.dirname(dir)
          if not dir or dir == '/' or dir == '' then break end
          local cands = { dir .. '/' .. pkg }
          vim.list_extend(cands, vim.fn.glob(dir .. '/*/' .. pkg, true, true))
          for _, c in ipairs(cands) do
            if not c:find('/node_modules/', 1, true) and name_matches(c, pkg) then
              found = c
              break
            end
          end
          if found then break end
        end

        pkg_dir_cache[key] = found
        return found or nil
      end

      local function sibling_uri(uri)
        local path = vim.uri_to_fname(uri)
        -- Already a symlinked workspace package? Nothing to fix.
        local realpath = vim.uv.fs_realpath(path)
        if realpath and not realpath:find('/node_modules/', 1, true) then return nil end

        local nm, pkg, rest = path:match('^(.*/node_modules)/(@[^/]+/[^/]+)/(.+)$')
        if not pkg then nm, pkg, rest = path:match('^(.*/node_modules)/([^/]+)/(.+)$') end
        if not pkg then return nil end

        local dir = find_pkg_dir(nm, pkg)
        if not dir then return nil end
        local real = dir .. '/' .. rest
        if vim.uv.fs_stat(real) then return vim.uri_from_fname(real) end
      end

      local function rewrite_locations(node)
        if type(node) ~= 'table' then return end
        for _, key in ipairs({ 'uri', 'targetUri' }) do
          if type(node[key]) == 'string' then
            node[key] = sibling_uri(node[key]) or node[key]
          end
        end
        for _, v in pairs(node) do rewrite_locations(v) end
      end

      vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pyright', 'clangd', 'gradle_ls', 'gopls', 'ts_ls', 'jsonls', 'zls' })

      -- scala comes from nvim-metals

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if not client then return end

          if redirect_clients[client.name] and not client.__sibling_redirect then
            client.__sibling_redirect = true
            local orig_request = client.request
            client.request = function(self, method, params, handler, bufnr)
              if redirect_methods[method] and handler then
                local inner = handler
                handler = function(err, result, ctx, cfg)
                  rewrite_locations(result)
                  return inner(err, result, ctx, cfg)
                end
              end
              return orig_request(self, method, params, handler, bufnr)
            end
          end

          local map = function(keys, func, desc)
            ---@diagnostic disable-next-line: missing-fields
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- vim.lsp.inlay_hint.enable(true, {bufnr=event.buf})
          map('<leader>th', function ()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({bufnr = event.buf}), {bufnr=event.buf})
          end, '[T]oggle Inlay [H]ints')


          local builtin = require('telescope.builtin')

          map('gr', builtin.lsp_references, 'Go References')
          map('gd', builtin.lsp_definitions, 'Go Definitions')
          map('gI', builtin.lsp_implementations, 'Go Implementations')
          map('gT', builtin.lsp_type_definitions, 'Go Type Definitions')
          map('gs', builtin.lsp_document_symbols, 'Document Symbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('gai', builtin.lsp_incoming_calls, 'Show incoming calls')
          map('gao', builtin.lsp_outgoing_calls, 'Show incoming calls')
          map('<leader>F', vim.lsp.buf.format, '[F]ormat current buffer')

          vim.keymap.set({ 'n' }, '<leader>k', function()
            vim.lsp.buf.signature_help()
          end, { silent = true, noremap = true, desc = 'toggle signature' })

          local formatting_enabled_filetypes = {}

          local function has_value(table, value)
            for _, val in ipairs(table) do
              if value == val then
                return true
              end
            end
            return false
          end

          if has_value(formatting_enabled_filetypes, vim.bo.filetype) and client:supports_method('textDocument/formatting') then
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
        bloopVersion = '2.1.0',
        inlayHints = {
          namedParameters = { enable = true },
          byNameParameters = { enable = true },
          inferredTypes = { enable = true },
          implicitArguments =  { enable = true },
          implicitConversions = { enable = true },
          hintsInPatternMatch = { enable = true },
          hintsXRayMode = { enable = true },
          closingLabels = { enable = true },
        },
      }

      local function get_operating_system()
        if jit then
          return jit.os
        end

        local fh, _ = assert(io.popen('uname -o 2>/dev/null', 'r'))

        if fh then
          return fh:read()
        else
          return 'Windows'
        end
      end

      local os = get_operating_system()

      if os == 'Darwin' or os == 'OSX' then
        metals_config.settings.gradleScript = '/opt/gradle/gradle-9.6.0/bin/gradle'
        metals_config.settings.javaHome = '/Library/Java/JavaVirtualMachines/liberica-jdk-25.jdk/Contents/Home'
        metals_config.settings.scalafixConfigPath = '/Users/jared.weiss/build/dotfiles/.scalafix.conf'
      end

      metals_config.init_options.globSyntax = 'vscode'
      metals_config.init_options.statusBarProvider = 'on'
      metals_config.capabilities = require('blink.cmp').get_lsp_capabilities()
      metals_config.flags = { debounce_text_changes = 1000 }

      vim.keymap.set('n', '<leader>mo', ':MetalsOrganizeImports<CR>')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt' },
        callback = function()
          -- Walk to the OUTERMOST ancestor with a real Bloop install (a .bloop
          -- dir containing build target JSONs). Innermost-match would pick
          -- subproject build.gradle (e.g. ring-master/) or scala-cli-polluted
          -- .metals dirs that the previous broken state created next to source
          -- files — both cause Metals to fall back to per-file scala-cli BSP,
          -- which litters .scala-build/ and .bsp/ and wrecks diagnostics.
          local file = vim.api.nvim_buf_get_name(0)
          local outermost = nil
          for dir in vim.fs.parents(file) do
            local bloop = dir .. '/.bloop'
            if vim.fn.isdirectory(bloop) == 1 and #vim.fn.glob(bloop .. '/*.json', false, true) > 0 then
              outermost = dir
            end
          end
          if outermost then
            metals_config.root_dir = outermost
          end
          require('metals').initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup('nvim-metals', { clear = true }),
      })
    end,
  }

}
