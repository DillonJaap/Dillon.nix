local wk = require("which-key")

-- ---------------------------------------------------------------------------
-- Helper: LSP keymaps
-- ---------------------------------------------------------------------------
local function register_lsp_keys(bufnr)
	local mappings = {
		-- Diagnostics
		{ "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
		{ "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
		{ "<leader>e", vim.diagnostic.open_float, desc = "Line Diagnostics" },
		{ "<leader>lq", vim.diagnostic.setloclist, desc = "Send to Loclist" },

		-- LSP navigation
		{ "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
		{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to Definition" },
		{ "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to Implementation" },
		{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "Go to References" },
		{ "gT", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Go to Type Definition" },

		-- Actions
		{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
		{ "<leader>lh", vim.lsp.buf.signature_help, desc = "Signature Help" },
		{ "<leader>ln", vim.lsp.buf.rename, desc = "Rename Symbol" },
		{
			"<leader>la",
			vim.lsp.buf.code_action,
			desc = "Code Action",
			mode = { "n", "v" },
		},

		-- Workspace
		{ "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder" },
		{ "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder" },
		{
			"<leader>lwl",
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			desc = "List Workspace Folders",
		},

		-- Calls
		{ "<leader>lC", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
		{ "<leader>lO", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },
		{ "<leader>lc", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incoming Calls (Telescope)" },
		{ "<leader>lo", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing Calls (Telescope)" },

		-- Group labels
		{ "<leader>l", group = "LSP" },
		{ "<leader>lw", group = "Workspace" },
	}

	wk.add(mappings, { buffer = bufnr })
end

-- ---------------------------------------------------------------------------
-- Common on_attach & capabilities
-- ---------------------------------------------------------------------------
local function on_attach(client, bufnr)
	register_lsp_keys(bufnr)
	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- nvim-cmp optional integration
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-------------------------------------------------------------------------------
-- Language Servers
-------------------------------------------------------------------------------

-- Lua
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
})

-- Go
vim.lsp.enable("gopls")
vim.lsp.config("gopls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = { buildFlags = { "-tags=integration,e2e" } },
	},
})

-- SQL
vim.lsp.enable("sqlls")
vim.lsp.config("sqlls", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "sql", "mysql", "sql.tmpl" },
})

-- OCaml
vim.lsp.enable("ocamllsp")
vim.lsp.config("ocamllsp", {
	on_attach = on_attach,
	capabilities = capabilities,
	-- cmd = { "dune", "exec", "--", "ocamllsp", "||", "ocamllsp" },
})

-- HTML
vim.lsp.enable("html")
vim.lsp.config("html", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
})

-- PHP
vim.lsp.enable("intelephense")
vim.lsp.config("intelephense", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Odin
vim.lsp.enable("ols")
vim.lsp.config("ols", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Nix
vim.lsp.enable("nil_ls")
vim.lsp.config("nil_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Terraform
vim.lsp.enable("terraformls")
vim.lsp.config("terraformls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Cypher
vim.lsp.enable("cypher_ls")
vim.lsp.config("cypher_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Gleam
vim.lsp.enable("gleam")
vim.lsp.config("gleam", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- YAML
vim.lsp.enable("yamlls")
vim.lsp.config("yamlls", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- Nushell
vim.lsp.enable("nushell")
vim.lsp.config("nushell", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- js/ts
vim.lsp.enable("ts_ls")
vim.lsp.config("ts_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
})
vim.lsp.enable("eslint")
vim.lsp.config("eslint", {
	on_attach = on_attach,
	capabilities = capabilities,
})

-- rescript
vim.lsp.enable("rescriptls")
vim.lsp.config("rescriptls", {
	on_attach = on_attach,
	settings = {
		rescript = {
			settings = {
				inlayHints = { enable = false },
			},
		},
	},
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
})

-- Elixir
vim.lsp.enable("expert")
vim.lsp.config("expert", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "expert", "--stdio" },
	root_markers = { "mix.exs", ".git" },
	filetypes = {
		"elixir",
		-- "eelixir",
		"heex",
	},
})

-- TailwindCSS (default + gleam)
vim.lsp.enable("tailwindcss")
vim.lsp.config("tailwindcss", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = {
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"django-html",
		"htmldjango",
		"edge",
		-- "eelixir",
		"elixir",
		"ejs",
		"erb",
		"eruby",
		"gohtml",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"htmlangular",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		-- "markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"gleam",
	},
	settings = {
		tailwindCSS = {
			includeLanguages = { gleam = "html" },
			experimental = {
				classRegex = {
					{ '\\w+\\.class\\("([^"]*)"\\)', '([^"]*)' },
					{ "\\w+\\.class\\('([^']*)'\\)", "([^']*)" },
					{ 'class\\("([^"]*)"\\)', '([^"]*)' },
					{ "class\\('([^']*)'\\)", "([^']*)" },
					{ '\\w+\\.class\\([\\s\\n]*"([^"]*)"[\\s\\n,]*\\)', '([^"]*)' },
					{ "\\w+\\.class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)", "([^']*)" },
					{ 'class\\([\\s\\n]*"([^"]*)"[\\s\\n,]*\\)', '([^"]*)' },
					{ "class\\([\\s\\n]*'([^']*)'[\\s\\n,]*\\)", "([^']*)" },
				},
			},
		},
	},
})
