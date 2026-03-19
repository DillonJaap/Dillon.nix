local ls = require 'luasnip'
local collection = require 'luasnip.session.snippet_collection'
--local types = require 'luasnip.util.types'

local s = ls.s -- snippet creator
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node

collection.clear_snippets("lua")

ls.add_snippets("lua", {
	ls.parser.parse_snippet("lf", "local $1 = function($2)\n	$0\nend"),
	s(
		"req",
		fmt([[local {} = require '{}']], {
			f(function(import_name)
				local parts = vim.split(import_name[1][1], ".", { plain = true })
				return parts[#parts] or "nope"
			end, { 1 }),
			i(1),
		})
	),
})
