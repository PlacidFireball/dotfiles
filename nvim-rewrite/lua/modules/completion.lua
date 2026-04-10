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
