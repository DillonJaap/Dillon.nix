local wk = require("which-key")

-- nvim 0.12 document_color assert fires when client detaches while state still
-- holds the id. Disable until upstream fix.
if vim.lsp.document_color then
	vim.lsp.document_color.enable(false)
end

-- ---------------------------------------------------------------------------
-- Helper: realign markdown tables in hover popovers
-- sqls emits ragged table rows and nvim renders raw markdown text, so pipes
-- never line up. Pad all cells so columns align.
-- ---------------------------------------------------------------------------
local function is_table_row(line)
	return line:match("^%s*|") ~= nil and line:match("|%s*$") ~= nil
end

local function align_table_block(block)
	local rows = {}
	for _, line in ipairs(block) do
		local body = line:match("^%s*|(.*)|%s*$")
		local cells = vim.split(body, "|")
		for idx, cell in ipairs(cells) do
			cells[idx] = vim.trim(cell)
		end
		rows[#rows + 1] = cells
	end

	local widths = {}
	for _, cells in ipairs(rows) do
		for idx, cell in ipairs(cells) do
			widths[idx] = math.max(widths[idx] or 0, vim.fn.strdisplaywidth(cell))
		end
	end

	local aligned = {}
	for _, cells in ipairs(rows) do
		local rendered = {}
		for idx, cell in ipairs(cells) do
			local w = widths[idx] or 0
			if cell:match("^:?%-+:?$") then
				local left = cell:match("^:")
				local right = cell:match(":$")
				local dashes = math.max(1, w - (left and 1 or 0) - (right and 1 or 0))
				cell = (left and ":" or "") .. string.rep("-", dashes) .. (right and ":" or "")
				cell = cell .. string.rep("-", w - #cell)
			end
			rendered[idx] = " " .. cell .. string.rep(" ", w - vim.fn.strdisplaywidth(cell)) .. " "
		end
		aligned[#aligned + 1] = "|" .. table.concat(rendered, "|") .. "|"
	end
	return aligned
end

local convert_to_markdown = vim.lsp.util.convert_input_to_markdown_lines
vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
	local lines = convert_to_markdown(input, contents)
	local out = {}
	local block = {}
	local in_code = false
	local function flush()
		if #block > 0 then
			vim.list_extend(out, align_table_block(block))
			block = {}
		end
	end
	for _, line in ipairs(lines) do
		line = line:gsub("&nbsp;", " ")
		if line:match("^%s*```") then
			flush()
			in_code = not in_code
			out[#out + 1] = line
		elseif not in_code and is_table_row(line) then
			block[#block + 1] = line
		else
			flush()
			out[#out + 1] = line
		end
	end
	flush()
	return out
end

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
	if client.name == "rescriptls" then
		return
	end
	if client:supports_method("textDocument/inlayHint") then
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
		gopls = { buildFlags = { "-tags=integration,e2e,performancetesting" } },
	},
})

-- Sql
vim.lsp.enable("sqls")
vim.lsp.config("sqls", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "sql", "mysql", "sql.tmpl" },
	root_markers = { ".git" },
	settings = {
		sqls = {
			lowercaseKeywords = true,
			connections = {
				{
					alias = "app",
					driver = "sqlite3",
					dataSourceName = "./sql/app.db",
				},
			},
		},
	},
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
