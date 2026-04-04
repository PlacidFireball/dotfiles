local h = require('config.helpers')

vim.pack.add(h.spec('nvim-lua/plenary.nvim', 'plenary'), h.po())
vim.pack.add(h.spec('MeanderingProgrammer/render-markdown.nvim', 'render-markdown'), h.po())
vim.pack.add(h.spec('sudo-tee/opencode.nvim', 'opencode'), h.po())

local mkdwn_set = false

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'opencode_output' },
  callback = function (_)
    if not mkdwn_set then
      require('render-markdown').setup {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
      }
      mkdwn_set = true
    end
  end
})

require('opencode').setup {
  preferred_picker = 'snacks',
  preferred_completion = 'blink',
  keymap = {
    editor = {
      ['<leader>cc'] = { 'toggle' },
    },
    input_window = {
      ['<CR>'] = { 'submit_input_prompt', mode = { 'n', 'i' } },
    }
  }
}
