return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier", stop_after_first = true },
				vue = { "prettier", stop_after_first = true },
				html = { "prettier", stop_after_first = true },
				go = { "gopls", "goimports", "goimports-revisor", stop_after_first = false },
				odin = { "odinfmt" },
				nix = { "nixpkgs-fmt" },
				ocaml = { "ocamlformat" },
				json = { "prettier" },
			},
		})
	end,
}
