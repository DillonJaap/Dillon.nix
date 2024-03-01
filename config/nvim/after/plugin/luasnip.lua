local ls = require 'luasnip'
local collection = require 'luasnip.session.snippet_collection'
local types = require 'luasnip.util.types'

local s = ls.s -- snippet creator
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep


--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------
ls.config.setup({ enable_autosnippets = true })


--------------------------------------------------------------------------------
-- Global Snippets
--------------------------------------------------------------------------------
collection.clear_snippets("all")

-- Repeat a node, but transform the text with the transform_func parameter
local transform = function(rep_position, transform_func)
	return f(function(args)
		return transform_func(args[1][1])
	end, { rep_position })
end

--ls.add_snippets("all", {
--})

--------------------------------------------------------------------------------
-- Lua Snippets
--------------------------------------------------------------------------------
collection.clear_snippets("lua")

ls.add_snippets("lua", {
	ls.parser.parse_snippet("lf", "local $1 = function($2)\n	$0\nend"),
	s(
		"req",
		fmt(
			[[local {} = require '{}']],
			{
				f(
					function(import_name)
						local parts = vim.split(import_name[1][1], '.', { plain = true })
						return parts[#parts] or "nope"
					end, { 1 }),
				i(1)
			}
		)
	),
})

--------------------------------------------------------------------------------
-- Go snippets
--------------------------------------------------------------------------------
require('djaap.snippets.go')

--------------------------------------------------------------------------------
-- Ocaml Snippets
--------------------------------------------------------------------------------
collection.clear_snippets("ocaml")

ls.add_snippets("ocaml", {
	s(
		{ trig = "(*", name = "comment", snippetType = "autosnippet" },
		fmt(
			[[(* {} *{}]], -- don't include the closing parenthesis because a plugin provides it
			{
				i(1),
				i(2)
			}
		)
	),
})

--------------------------------------------------------------------------------
-- Key Mappings
--------------------------------------------------------------------------------
local keymap = {
	['<c-k>'] = {
		function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end,
		'snippet: expand or jump',
		mode = { 'i', 's' },
	},
	['<S-Right>'] = {
		function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end,
		'snippet: expand or jump',
		mode = { 'i', 's' },
	},
	['<c-m>'] = {
		function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end,
		'snippet: jump prev',
		mode = { 'i', 's' },
	},
	['<S-Left>'] = {
		function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end,
		'snippet: jump prev',
		mode = { 'i', 's' },
	},
	['<c-l>'] = {
		function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end,
		'snippet: jump prev',
		mode = { 'i', 's' },
	},
	['<leader>LS'] = { "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>" },
}

require('which-key').register({ keymap })
