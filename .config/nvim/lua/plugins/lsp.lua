return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'ts_ls',
          'jsonls',
          'yamlls',
          'taplo',
        },
      })
      require('mason-tool-installer').setup({
        ensure_installed = { 'biome', 'prettier' }, -- formatter
      })

      local servers = { 'lua_ls', 'pyright', 'ts_ls', 'jsonls', 'yamlls', 'taplo' }

      for _, server in ipairs(servers) do
        -- nixd pkg is managed by nix home manager
        vim.lsp.enable(server)
      end
    end,
  },
}
