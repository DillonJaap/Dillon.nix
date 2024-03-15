return {
	'sainnhe/gruvbox-material', -- colorscheme
	'Mofiqul/dracula.nvim',
	'folke/tokyonight.nvim',
	'rebelot/kanagawa.nvim',
	'shaunsingh/nord.nvim',
	'HoNamDuong/hybrid.nvim',
	'tjdevries/colorbuddy.vim',
	'tjdevries/gruvbuddy.nvim',
	{ 'rose-pine/neovim',              name = 'rose-pine' },


	'stevearc/dressing.nvim',             -- dressing (vim.input replacement)
	'mrjones2014/legendary.nvim',
	'lukas-reineke/indent-blankline.nvim', -- visual indent
	'tpope/vim-fugitive',
	'ThePrimeagen/vim-be-good',
	'nvim-lua/plenary.nvim',
	'projekt0n/caret.nvim',
	'vrischmann/tree-sitter-templ',


	{ "cbochs/grapple.nvim" },
	{ 'simrat39/symbols-outline.nvim', config = function() require("symbols-outline").setup() end },
	{ "aserowy/tmux.nvim",             config = function() require("tmux").setup() end },
	{ "windwp/nvim-autopairs",         config = function() require("nvim-autopairs").setup {} end },
	--{ 'phaazon/hop.nvim',              config = function() require('hop').setup() end },


	-- Toggle Term
	{
		"akinsho/toggleterm.nvim",
		version = '*',
		config = function() require("toggleterm").setup({}) end,
	},

	-- Structural Join
	{
		'Wansmer/treesj',
		config = function()
			require('treesj').setup({ use_default_keymaps = false })
		end,
	},
	-- Neo-Tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim"
		},
	},
	{
		--"jonathanmorris180/salesforce.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		}
	}
}
