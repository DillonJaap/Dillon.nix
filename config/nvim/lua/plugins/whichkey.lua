return {
	{
		'folke/which-key.nvim',
		config = function()
			require('which-key').setup {
				window = {
					border = "double",
				},
				layout = {
					align = "center",
				}
			}
		end
	}
}
