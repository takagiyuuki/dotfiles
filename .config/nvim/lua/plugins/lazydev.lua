-- lua/plugins/lazydev.lua

return{
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = {'DrKJeff16/wezterm-types'},
  opts = {
    library = {
      -- WezTerm types
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  },
}
