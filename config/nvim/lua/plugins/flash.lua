return { {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			char = {
				enabled = false,
				search = { wrap = false },
				highlight = { backdrop = true },
				jump = { register = false },
			}
		}
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				-- default options: exact mode, multi window, all directions, with a backdrop
				require("flash").jump()
			end,
		},
		{
			"S",
			mode = { "o", "x" },
			function()
				require("flash").treesitter()
			end,
		},
	},
} }
