return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()

			local lspconfig = require("lspconfig")

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ts_ls", "nixd" },
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({})
					end,
				},
			})
		end,
	},
}
