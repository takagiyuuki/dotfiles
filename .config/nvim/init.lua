print("init.lua loaded")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

vim.opt.mouse = ""
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.undofile = true

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

vim.api.nvim_create_user_command(
    'InitLua',
    function()
        vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
    end,
    {}
)

