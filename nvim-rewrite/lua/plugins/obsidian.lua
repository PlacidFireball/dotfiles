return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    require('obsidian').setup {
      workspaces = {
        {
          name = "placidfireball",
          path = "~/Documents/Obsidian/placidfireball/",
        },
      },
    }
  end,
}
