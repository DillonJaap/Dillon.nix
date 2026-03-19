return {
	'nvim-telescope/telescope-fzy-native.nvim',
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('telescope').setup {
				defaults = {
					layout_strategy = 'horizontal',
					sorter = 'fzf-native'
				},
				pickers = {
					find_files = {
						--theme = "dropdown"
						mappings = {
							i = { ["<c-f>"] = require('telescope.actions').to_fuzzy_refine },
						},
					},
					git_files = {
						--theme = "dropdown"
						mappings = {
							i = { ["<c-f>"] = require('telescope.actions').to_fuzzy_refine },
						},
					},
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					}
				}
			}
			--require('telescope').load_extension('git_worktree')
			--require('telescope').load_extension('projects')
			--require('telescope').load_extension('fzy_native')
		end
	},
}
