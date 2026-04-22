return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      -- defaults seem sane, imma leave this here
      require("nvim-autopairs").setup {}
    end
  }
}
