local register_lsp_keys = function(bufno)
	local list_workspaces = function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end

	local lsp_keymaps = {
		-- diagnostics
		['[d'] = { vim.diagnostic.goto_next, 'goto next diagnostic', buffer = bufno },
		[']d'] = { vim.diagnostic.goto_prev, 'goto prev diagnostic', buffer = bufno },
		['<leader>e'] = { vim.diagnostic.open_float, 'Open floating diagnostic', buffer = bufno },
		['<leader>lq'] = { vim.diagnostic.setqflist, 'diagnostic setloclist', buffer = bufno },
		['gD'] = { vim.lsp.buf.declaration, 'Goto Declaration', buffer = bufno },
		['gr'] = { '<cmd>Telescope lsp_references<cr>', 'Goto References', buffer = bufno },
		['gi'] = { '<cmd>Telescope lsp_implementations<cr>', 'Goto Implementations', buffer = bufno },
		['gd'] = { '<cmd>Telescope lsp_definitions<cr>', 'Goto Definitions', buffer = bufno },
		['gT'] = { '<cmd>Telescope lsp_type_definitions<cr>', 'Goto Type Definitions', buffer = bufno },
		['<leader>lc'] = {
			'<cmd>Telescope lsp_incoming_calls<cr>',
			'Incoming calls',
			mode = { 'n', 'v' },
			buffer = bufno,
		},
		['<leader>lo'] = {
			'<cmd>Telescope lsp_outgoing_calls<cr>',
			'Outgoing calls',
			mode = { 'n', 'v' },
			buffer = bufno,
		},
		-- quickfix
		['<leader>lr'] = { vim.lsp.buf.references, 'References', buffer = bufno },
		['<leader>li'] = { vim.lsp.buf.implementation, 'Implementations', buffer = bufno },
		['<leader>ld'] = { vim.lsp.buf.definition, 'Definitions', buffer = bufno },
		['<leader>lt'] = { vim.lsp.buf.type_definition, 'Type Definitions', buffer = bufno },
		['<leader>lC'] = { vim.lsp.buf.incoming_calls, 'Incoming calls', mode = { 'n', 'v' }, buffer = bufno },
		['<leader>lO'] = { vim.lsp.buf.outgoing_calls, 'Outgoing calls', mode = { 'n', 'v' }, buffer = bufno },
		-- lsp misc actions
		['K'] = { vim.lsp.buf.hover, 'Show Documentation/Definition', buffer = bufno },
		['<leader>lh'] = { vim.lsp.buf.signature_help, 'Signature help', buffer = bufno },
		['<leader>ln'] = { vim.lsp.buf.rename, 'Rename', buffer = bufno },
		['<leader>lf'] = { vim.lsp.buf.format, 'Format code', buffer = bufno },
		['<leader>la'] = { vim.lsp.buf.code_action, 'Code action', mode = { 'n', 'v' }, buffer = bufno },
		-- workspaces
		['<leader>lwa'] = { vim.lsp.buf.add_workspace_folder, 'Add workspace folder', buffer = bufno },
		['<leader>lwr'] = { vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder', buffer = bufno },
		['<leader>lwl'] = { list_workspaces, 'List workspace folders', buffer = bufno },
	}
	require('which-key').register({ lsp_keymaps })
end


local custom_on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true }
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	register_lsp_keys(bufnr)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover, {
			border = "single",
		}
	)

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help, {
			border = "single",
		}
	)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

require("neodev").setup({
	pathStrict = true,
	-- add any options here, or leave empty to use the default settings
})

local lsp = require("lsp-zero")

lsp.on_attach(custom_on_attach)

--lsp.lsp_flags(lsp_flags)

require('lspconfig').lua_ls.setup(
	lsp.nvim_lua_ls({
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { 'vim' },
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				completion = {
					callSnippet = "Replace"
				}
			}
		}
	})
)

require('lspconfig').gopls.setup({
	settings = {
		gopls = {
			buildFlags = { "-tags=integration,e2e" }
		}
	}
})

require('lspconfig').sqlls.setup({
	settings = {},
	filetypes = { "sql", "mysql", "sql.tmpl" },
})

require('lspconfig').ocamllsp.setup({
	on_attach = function()
		--vim.cmd(":!dune build --watch &")
	end
})

require('lspconfig').html.setup({
	filetypes = { "templ", "html" },
})

require('lspconfig').apex_ls.setup {
	filetypes = { "apexcode", "apex" },
}

require 'lspconfig'.templ.setup {
	filetypes = { "templ" },
}

require 'lspconfig'.ols.setup {}
require'lspconfig'.nil_ls.setup{}

lsp.setup()
