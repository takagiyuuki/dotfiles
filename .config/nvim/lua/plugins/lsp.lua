return {
  {
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Neovim 0.11+ 正式 API
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("pyright", {})
      vim.lsp.config("ts_ls", {})
    end,
  },
}

