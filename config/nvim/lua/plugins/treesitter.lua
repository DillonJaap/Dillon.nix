return {
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ':TSUpdate',
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = { "go", "lua", "bash", "javascript", "gleam", "tsx", "markdown", "markdown_inline" },
			})
		end,
	},
	--
	-- Treesitter Text Objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- put your config here
		end,
	}
}
