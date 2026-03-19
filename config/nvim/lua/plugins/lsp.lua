return {
	{ "neovim/nvim-lspconfig" }, -- Required
	{
		"mason-org/mason.nvim",
		opts = {},
		config = function() 
			require("mason").setup()
		end 
	},
	-- Autocompletion
	{ "hrsh7th/nvim-cmp" }, -- Required
	{ "hrsh7th/cmp-nvim-lsp" }, -- Required
}
