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
      }
    },
    version = 'v0.*',
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
    config = function()
      require("blink.cmp").setup {
        keymap = {
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-k>'] = { 'snippet_forward', 'fallback' },
          ['<C-j>'] = { 'snippet_backward', 'fallback' },
        },
        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- will be removed in a future release
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },

        snippets = {
          expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
          active = function(filter)
            if filter and filter.direction then
              return require('luasnip').jumpable(filter.direction)
            end
            return require('luasnip').in_snippet()
          end,
          jump = function(direction) require('luasnip').jump(direction) end,
        },

        sources = {
          default = { 'lsp', 'path', 'luasnip', 'buffer' },
        },

        -- experimental signature help support
        signature = { enabled = true }
      }
      require("modules.completion")
    end,
  },
}
