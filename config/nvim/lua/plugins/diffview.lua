return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>' },
    { '<leader>gh', '<cmd>DiffviewFileHistory<cr>' },
  },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
}
