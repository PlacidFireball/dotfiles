return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      anti_conceal = { enabled = false },
      file_types = { 'markdown', 'opencode_output' },
    },
    ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    config = function()
      require('render-markdown').setup {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
        checkbox = {
          right_pad = 1,
        },
        bullet = {
          right_pad = 0,
        },
      }
    end
  },
}
