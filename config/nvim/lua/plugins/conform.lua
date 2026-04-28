return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = function(bufnr)
				if vim.bo[bufnr].filetype == "rescript" then
					return nil
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascriptreact = { "prettier", stop_after_first = true },
				javascript = { "prettier", stop_after_first = true },
				typescriptreact = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
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
