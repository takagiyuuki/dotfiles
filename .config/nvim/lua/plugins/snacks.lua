-- lua/plugins/snacks.lua
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    terminal = { enabled = true },
  },
}
