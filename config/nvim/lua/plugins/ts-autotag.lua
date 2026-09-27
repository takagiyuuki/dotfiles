-- lua/plugins/ts-autotag.lua
-- Auto close and auto rename HTML/JSX/Astro tags via Treesitter.
return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {},
}
