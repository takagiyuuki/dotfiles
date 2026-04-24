return {
  'stevearc/aerial.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('aerial').setup({
      layout = { default_direction = 'right', min_width = 30 },
    })
    vim.keymap.set('n', '<leader>A', '<CMD>AerialToggle<CR>')
  end,
}
