return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{
							function()
								local key = require("grapple").key()
								return "  [" .. key .. "]"
							end,
							cond = require("grapple").exists,
						},
						"branch", "diff", "diagnostics",
					},
					lualine_c = {
						{ 'filename', path = 1 }
					}
				},
				inactive_sections = {
					lualine_b = {
						{
							function()
								local key = require("grapple").key()
								return "  [" .. key .. "]"
							end,
							cond = require("grapple").exists,
						}
					},
					lualine_c = {
						{ 'filename', path = 1 }
					}
				}
			}
		end
	}
}
