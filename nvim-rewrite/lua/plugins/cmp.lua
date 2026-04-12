---@diagnostic disable: missing-fields
return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
      },
      "Kaiser-Yang/blink-cmp-avante"
    },
    version = '1.*',
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
    config = function()
      require("blink.cmp").setup {
        keymap = {
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<C-a>'] = { 'accept', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-j>'] = { 'snippet_forward', 'fallback' },
          ['<C-k>'] = { 'snippet_backward', 'fallback' },
        },
        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- will be removed in a future release
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
              kind_resolution = {
                enabled = true,
                blocked_filetypes = { 'typescript', 'javascriptreact', 'vue', 'scala' }
              }
            }
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
          },
          ghost_text = { enabled = true },
          menu = {
            draw = {
              treesitter = { 'lsp' }
            }
          },
        },
        sources = {
          default = { 'snippets', 'lsp', 'path', 'buffer' },
        },
        snippets = {
          preset = 'luasnip'
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        -- experimental signature help support
        signature = { enabled = true }
      }
      require("modules.completion")
    end,
  },
}
