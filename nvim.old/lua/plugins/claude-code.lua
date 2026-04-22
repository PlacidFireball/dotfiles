return {
  "greggh/claude-code.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claude-code").setup {
      window = {
        position = "vertical",
        split_ration = 0.25,
      }
    }

    vim.keymap.set("n", "<leader>cc", "<CMD>ClaudeCode<CR>", { desc = "Launch [C]laude [C]ode"})
  end,
}
