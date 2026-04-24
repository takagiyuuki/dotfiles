return {
  'rose-pine/nvim',
  -- 'catppuccin/nvim',
  -- name = 'catppuccin',
  name = 'rose-pine',
  priority = 1000,
  config = function()
    -- vim.cmd.colorscheme('catppuccin-mocha')
    vim.cmd.colorscheme('rose-pine')
  end,
}
