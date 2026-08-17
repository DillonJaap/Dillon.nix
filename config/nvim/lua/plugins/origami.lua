return {
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = {
			useLspFoldsWithTreesitterFallback = {
				enabled = true,
				foldmethodIfNeitherIsAvailable = "indent",
			},
			pauseFoldsOnSearch = true,
			foldtext = {
				enabled = true,
				lineCount = {
					template = "%d lines",
					hlgroup = "Comment",
				},
				diagnosticsCount = true,
				gitsignsCount = true,
				disableOnFt = { "snacks_picker_input" },
			},
			autoFold = {
				enabled = true,
				kinds = { "imports" },
			},
			foldKeymaps = {
				setup = true,
				closeOnlyOnFirstColumn = false,
				scrollLeftOnCaret = false,
			},
		},
	},
}