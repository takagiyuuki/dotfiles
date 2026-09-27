return {
  'kepano/flexoki-neovim',
  name = 'flexoki',
  -- 'rose-pine/nvim', name = 'rose-pine',
  -- 'catppuccin/nvim', name = 'catppuccin'
  priority = 1000,
  config = function()
    vim.cmd.colorscheme('flexoki-light')
  end,
}
