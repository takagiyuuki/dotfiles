return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local servers = {
        'lua_ls',
        'pyright',
        'ts_ls',
        'jsonls',
        'yamlls',
        'taplo',
        'nixd',
        'bashls',
        'terraformls',
        'rust_analyzer',
        'astro',
        'tailwindcss',
        'cssls',
        'marksman',
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
      end

      -- cssls custom rule for Tailswind v4 directives.
      vim.lsp.config('cssls', {
        settings = {
          css = { lint = { unknownAtRules = 'ignore' } },
          scss = { lint = { unknownAtRules = 'ignore' } },
          less = { lint = { unknownAtRules = 'ignore' } },
        },
      })

      -- Disable astro LSP formatting (it requires prettier + prettier-plugin-astro,
      -- which we don't install). Biome handles .astro formatting via conform.nvim.
      vim.lsp.config('astro', {
        on_attach = function(client, _bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
    end,
  },
}
