return {
  'mfussenegger/nvim-lint',
  -- BufReadPre (not BufReadPost): the plugin must be loaded *before* the
  -- event its own autocmd listens to, otherwise the first buffer is skipped.
  -- BufNewFile covers the same gap for files that do not exist yet.
  event = { 'BufReadPre', 'BufNewFile', 'BufWritePost' },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      python = { 'ruff' },
      nix = { 'statix' },
      javascript = { 'biomejs' },
      typescript = { 'biomejs' },
      css = { 'biomejs' },
      terraform = { 'tflint' },
      markdown = { 'markdownlint' },
      astro = { 'biomejs' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
