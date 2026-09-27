return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>' },
    { '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>' },
  },
  opts = {},
}
