-- lua/plugins/conform.lua
return {
  'stevearc/conform.nvim',
  opts = {
    formatters = {
      kdlfmt = {
        command = 'kdlfmt',
        args = { 'format', '--kdl-version', 'v1', '-' },
        stdin = true,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      nix = { 'nixfmt' },
      json = { 'biome' },
      typescript = { 'biome' },
      typescriptreact = { 'biome' },
      javascript = { 'biome' },
      javascriptreact = { 'biome' },
      markdown = { 'prettier' },
      yaml = { 'yamlfmt' },
      toml = { 'taplo' },
      kdl = { 'kdlfmt' },
      css = { 'biome' },
      sh = { 'shfmt' },
      astro = { 'biome' },
      terraform = { 'terraform_fmt' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)
    vim.api.nvim_create_user_command('Format', function()
      require('conform').format({ async = true, lsp_format = 'fallback' })
    end, { desc = 'Format current buffer' })
  end,
}
