return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ts_ls" },
			})

			local servers = { "lua_ls", "pyright", "ts_ls" }

			for _, server in ipairs(servers) do
				-- nixd pkg is managed by nix home manager
				vim.lsp.enable(server)
			end
		end,
	},
}
