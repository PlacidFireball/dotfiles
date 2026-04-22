return {
  {
    'stevearc/overseer.nvim',
    enabled = true,
    config = function()
      require "overseer".setup {
        templates = { "builtin", "user.run_script" }
      }
    end
  }
}
