return {
	"tarides/ocaml.nvim",
	config = function()
		require("lazy").setup({
			{
				"tarides/ocaml.nvim",
				config = function()
					require("ocaml").setup()
				end
			}
		})
	end
}
