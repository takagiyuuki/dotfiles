-- lua/plugins/tree-sitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('nvim-treesitter').setup({
      ensure_installed = {
        'lua',
        'vim',
        'vimdoc',
        'bash',
        'json',
        'rust',
        'javascript',
        'markdown',
        'markdown_inline',
      },
      highlight = {
        enable = true,
      },
    })
  end,
}
