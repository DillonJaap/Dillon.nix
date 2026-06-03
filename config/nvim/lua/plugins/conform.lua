return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")
		local formatOpts = { timeout_ms = 500, lsp_format = "fallback" }

		conform.setup({
			format_on_save = function(bufnr)
				if vim.bo[bufnr].filetype == "rescript" then
					return nil
				end
				return formatOpts
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

		local rescriptFormatOnSave = vim.api.nvim_create_augroup("rescript_format_on_save", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = rescriptFormatOnSave,
			pattern = { "*.res", "*.resi" },
			callback = function(args)
				pcall(vim.cmd, "silent! mkview!")
				conform.format(vim.tbl_extend("force", formatOpts, { bufnr = args.buf, async = false }))
				pcall(vim.cmd, "silent! loadview")
			end,
		})
	end,
}
