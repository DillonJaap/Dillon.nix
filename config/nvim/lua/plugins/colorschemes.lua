return {
	"sainnhe/gruvbox-material", -- colorscheme
	"Mofiqul/dracula.nvim",
	"folke/tokyonight.nvim",
	"rebelot/kanagawa.nvim",
	"shaunsingh/nord.nvim",
	"HoNamDuong/hybrid.nvim",
	"tjdevries/colorbuddy.vim",
	"tjdevries/gruvbuddy.nvim",
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"everviolet/nvim",
		name = "evergarden",
		priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
		opts = {
			theme = {
				variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
				accent = "green",
			},
			editor = {
				transparent_background = false,
				override_terminal = true,
				sign = { color = "none" },
				float = {
					color = "mantle",
					solid_border = false,
				},
				completion = {
					color = "surface0",
				},
			},
		},
	},
}
