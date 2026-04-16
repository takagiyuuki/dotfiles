return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.icons").setup({
				mock_nvim_web_devicons = true,
			})
		end,
	},
}
