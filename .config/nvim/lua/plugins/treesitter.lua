-- lua/plugins/treesitter.lua
return{
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "rust", "javascript" },
        highlight = {
          enable = true,
        },
      }
    )
  end,
}


