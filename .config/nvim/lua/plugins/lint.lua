return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPost', 'BufWritePost' },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      python = { 'ruff' },
      nix = { 'statix' },
      javascript = { 'biomejs' },
      typescript = { 'biomejs' },
      css = { 'biomejs' },
      terraform = { 'tflint' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
