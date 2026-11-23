return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "lewis6991/gitsigns.nvim"
  },
  config = function()
    vim.g.scrollbar_v2_notice = false
    require("scrollbar").setup {}

    require("scrollbar.handlers.search").setup {}
    -- gitsigns is configured in another castle
    require("scrollbar.handlers.gitsigns").setup()
  end

}
