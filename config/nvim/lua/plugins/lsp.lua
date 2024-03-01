return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
	},
	{ 'neovim/nvim-lspconfig' },  -- Required
	{
		-- Optional
		'williamboman/mason.nvim',
		build = function()
			pcall(vim.cmd, 'MasonUpdate')
		end,
	},
	{ 'williamboman/mason-lspconfig.nvim' },  -- Optional

	-- Autocompletion
	{ 'hrsh7th/nvim-cmp' },      -- Required
	{ 'hrsh7th/cmp-nvim-lsp' },  -- Required

	-- for neovim development
	{ 'folke/neodev.nvim',                opts = {} },
}
