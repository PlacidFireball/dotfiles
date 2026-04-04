local h = require('config.helpers')

vim.pack.add(h.spec('rafamadriz/friendly-snippets', 'friendly-snippets'), h.po())
vim.pack.add(h.spec('Kaiser-Yang/blink-cmp-avante', 'blink-cmp-avante'), h.po())
vim.pack.add(h.spec('L3MON4D3/LuaSnip', 'luasnip'), h.po())
vim.pack.add(h.spec('saghen/blink.cmp', 'blink.cmp'), h.po())

require('blink.cmp').setup {
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

  snippets = {
    preset = 'luasnip'
  },

  sources = {
    default = { 'snippets', 'lsp', 'avante', 'path' },
    providers = {
      avante = {
        module = 'blink-cmp-avante',
        name = 'Avante',
        opts = {}
      }
    }
  },

  -- experimental signature help support
  signature = { enabled = true }
}

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local luasnip = require "luasnip"

luasnip.config.set_config {
  history = false,
  updateevents = "TextChanged,TextChangedI"
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/modules/snippets/*.lua", true)) do
  loadfile(ft_path)()
end

