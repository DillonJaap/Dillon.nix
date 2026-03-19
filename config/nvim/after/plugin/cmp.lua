vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require('cmp')
if cmp == nil then
	return nil
end

local border = {
	{ "╭", "CmpBorder" },
	{ "─", "CmpBorder" },
	{ "╮", "CmpBorder" },
	{ "│", "CmpBorder" },
	{ "╯", "CmpBorder" },
	{ "─", "CmpBorder" },
	{ "╰", "CmpBorder" },
	{ "│", "CmpBorder" },
}

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-CR>"] = cmp.mapping.confirm({ select = false }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "path" },
		{ name = "omni" },
		{ name = "cody" },
		{
			name = 'spell',
			option = {
				keep_all_entries = false,
				enable_in_context = function()
					return true
				end,
			},
		},
	}, {
		{ name = "buffer" }
	}),
	window = {
		documentation = {
			border = border,
		},
		completion = {
			border = border,
		},
	},
})
