return {
	"windwp/nvim-autopairs",
	config = function()
		local npairs = require("nvim-autopairs")
		npairs.setup({})

		-- Disable single quote auto-pairing for OCaml (used as type parameter syntax)
		for _, rule in ipairs(npairs.get_rules("'")) do
			rule.not_filetypes = { "ocaml" }
		end
	end,
}
