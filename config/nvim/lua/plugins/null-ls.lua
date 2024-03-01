return {
	{
		'jose-elias-alvarez/null-ls.nvim',
		config = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			-- you can reuse a shared lspconfig on_attach callback here
			local on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end

			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.completion.spell,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.beautysh,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.goimports_reviser,
					null_ls.builtins.formatting.ocamlformat,
					null_ls.builtins.formatting.sql_formatter,
				},
				on_attach = on_attach,
			})
		end,
	}
}
