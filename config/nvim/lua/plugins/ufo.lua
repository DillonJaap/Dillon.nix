return {
	{
		'kevinhwang91/nvim-ufo',
		config = function()
			require('ufo').setup({
				---@diagnostic disable-next-line: unused-local
				provider_selector = function(bufnr, filetype, buftype)
					return { 'treesitter', 'indent' }
				end
			})
		end,
		dependencies = 'kevinhwang91/promise-async',
	},
}
