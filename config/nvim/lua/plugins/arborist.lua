return {
	"arborist-ts/arborist.nvim",
	lazy = false,
	config = function()
		require("arborist").setup({
			ensure_installed = { "ocaml", "ocaml_interface", "ocamllex", "odin", "gleam" }
		})
	end,
}
