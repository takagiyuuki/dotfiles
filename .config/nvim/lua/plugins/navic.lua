return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  init = function()
    vim.g.navic_silence = true
  end,
  config = function()
    require('nvim-navic').setup({ lazy_update_context = true })
  end,
}
