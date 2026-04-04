local h = require('config.helpers')

vim.pack.add(h.spec('windwp/nvim-autopairs', 'nvim-autopairs'), h.po())

local ok, autopairs = pcall(require, "nvim-autopairs")
if not ok then return end

autopairs.setup({
  check_ts = true, -- rely on treesitter for more intelligent pairing
  disable_filetype = { "TelescopePrompt" , "vim" },
})
