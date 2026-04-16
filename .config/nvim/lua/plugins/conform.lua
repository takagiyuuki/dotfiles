-- lua/plugins/confirm.lua
return {
  'stevearc/conform.nvim',
  opts = {
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
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'failback',
    },
  },
}
