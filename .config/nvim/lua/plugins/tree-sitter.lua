-- lua/plugins/tree-sitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main', -- rewrite branch (explicit)
  build = ':TSUpdate',
  lazy = false, -- main-branch highlight setup is fragile under lazy-loading
  config = function()
    local ts = require('nvim-treesitter')

    ts.install({
      'lua',
      'vim',
      'vimdoc',
      'bash',
      'json',
      'rust',
      'javascript',
      'markdown',
      'markdown_inline',
      'nix',
      'python',
      'go',
      'typescript',
      'tsx',
      'html',
      'astro',
      'yaml',
      'toml',
      'kdl',
      'terraform',
      'hcl',
    })

    -- Highlighting is a core Neovim feature on the main branch.
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
