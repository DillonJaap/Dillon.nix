local ls = require 'luasnip'
local collection = require 'luasnip.session.snippet_collection'
--local types = require 'luasnip.util.types'

local s = ls.s -- snippet creator
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
--local rep = require("luasnip.extras").rep

local ts_locals = require('nvim-treesitter.locals')
local get_tsnode_text = vim.treesitter.get_node_text

-- Clear go snippets
collection.clear_snippets("go")

-- Repeat a node, but transform the text with the transform_func parameter
local transform = function(rep_position, transform_func)
	return f(function(args)
		return transform_func(args[1][1])
	end, { rep_position })
end

local error_node = function(err)
	local nodes = {}
	table.insert(nodes, t(err))
	table.insert(nodes, sn(nil, fmt(
		'fmt.Errorf("{}: %w", {})',
		{ i(1), t(err) }
	)))
	table.insert(nodes, sn(nil, fmt(
		'fmt.Errorf("%w: %w", {}, {})',
		{ i(1), t(err) }
	)))
	return c(1, nodes)
end

local node_from_tsnode = function(type, info)
	if type == "int" then
		return t "0"
	end
	if type == "string" then
		return t [[""]]
	end
	if type == "bool" then
		return t "false"
	end
	if type == "error" then
		return error_node(info["error_name"])
	end
	if string.find(type, "*", 1, true) ~= nil then
		return t "nil"
	end
	if string.find(type, "[]", 1, true) ~= nil then
		return t "nil"
	end
	return t(type .. "{}")
end


local nodes_from_tsnode = function(node, info)
	if node:type() ~= "parameter_list" then
		return { node_from_tsnode(get_tsnode_text(node, 0), info) }
	end

	local tbl = {}
	local pos = 0
	for n in node:iter_children() do
		if n:named() then
			table.insert(tbl, node_from_tsnode(get_tsnode_text(n, 0), info))
			table.insert(tbl, t ", ")
			pos = pos + 1
		end
	end
	table.remove(tbl)
	return tbl
end

local get_return_nodes = function(info)
	local query = vim.treesitter.query.parse("go",
		[[
			[
				(method_declaration result: (_) @id)
				(function_declaration result: (_) @id)
				(func_literal result: (_) @id)
			]
		]]
	)

	local cursor_node = vim.treesitter.get_node()
	local scope = ts_locals.get_scope_tree(cursor_node, 0)
	local function_node

	for _, v in ipairs(scope) do
		if v:type() == "function_declaration"
				or v:type() == "func_literal"
				or v:type() == "method_declaration" then
			function_node = v
			break
		end
	end

	for _, node in query:iter_captures(function_node, 0) do
		return nodes_from_tsnode(node, info)
	end
	return nil
end

local return_node = function(position, rep_position)
	return d(position, function(args)
		local info = {}
		info["error_name"] = args[1][1]
		local nodes = get_return_nodes(info)
		return sn(nil, nodes)
	end, { rep_position })
end


local extractCapitalLetters = function(str)
	local capitalLetters = ""
	local indx = 1

	if str:sub(indx, indx) == "*" then
		indx = indx + 1
	end

	capitalLetters = str:sub(indx, indx)
	indx = indx + 1

	for indx_ = indx, #str do
		local char = str:sub(indx_, indx_)

		if char:match("[A-Z]") then
			capitalLetters = capitalLetters .. char
		end
	end

	return capitalLetters:lower()
end

-------------------------------------------------------------------------------
-- swagger snippets
-------------------------------------------------------------------------------

ls.add_snippets("go", {
	s(
		"func",
		fmt(
			[[
			func {}({}) {} {{
				{}
			}}
			]],
			{
				i(1, "name"),
				i(2),
				i(3),
				c(4, { fmt('{}\n\treturn {} ', { i(2), i(1) }), i(nil) }),
			}
		)
	),
	s(
		"meth",
		fmt(
			[[
			func ({} {}) {}({}) {} {{
				{}
			}}
			]],
			{
				transform(1, extractCapitalLetters),
				i(1),
				i(2, "name"),
				i(3),
				i(4),
				c(5, { fmt('{}\n\treturn {} ', { i(2), i(1) }), i(nil) }),
			}
		)
	),
	s(
		"funct",
		fmt(
			[[
			func Test{}(t *testing.T) {{
				tests := []struct{{
					{}
				}}{{
					{{
						{}
					}},
				}}

				for _, tt := range tests {{
					t.Run(tt.name, func(t *testing.T) {{
						{}
					}})
				}}
			}}
			]],
			{
				i(1, "func"),
				c(2, {
					fmt([[
					name string
					wantErr error{1}
					]], i(1)),
					t "",
				}),
				c(3, {
					fmt([[
					name: "Success",
					wantErr: nil,{}
					]], i(1)),
					t "",
				}),
				i(4),
			}
		)
	),
	s(
		"ife",
		fmt(
			[[
			if {1} != nil {{
				return {2}
			}}
			]],
			{
				i(1, "err"),
				return_node(2, 1),
			}
		)
	),
	s(
		"oass",
		fmt(
			[[
			// {}
			//
			// swagger:model
			]],
			{
				i(1, "CreateUpdateRequestWrapper represents a request to insert/update a beneficiary profile")
			}
		)
	),
	s(
		"oase",
		fmt(
			[[
			// swagger:route {} {} {} {}
			// {}
			//
			// ---
			// parameters:
			// + name: {}
			//   in: body
			//   schema:
			//     type: {}
			//   required: true
			// responses:
			//  200: {}
			// extensions:
			//  x-meta-Classification: {}
			]],
			{
				i(1, "POST"),
				i(2, "/route/path"),
				i(3, "interventions"),
				i(4, "operationId"),
				i(5, "description"),
				i(6, "createUpdate"),
				i(7, "CreateUpdateRequestWrapper"),
				i(8, "CreateUpdateResponseWrapper"),
				c(9, { t "Internal", t "External", t "Private", t "In Development" })

			}
		)
	)
})

-------------------------------------------------------------------------------
-- CharaChorder snippets
-------------------------------------------------------------------------------

ls.add_snippets("go", {
	s(
		{ trig = "func~~ ", name = "function", snippetType = "autosnippet" },
		fmt(
			[[
			func {}({}) {} {{
				{}
			}}
			]],
			{
				i(1, "name"),
				i(2),
				i(3),
				i(4),
			}
		)
	),
	s(
		{ trig = "method~~ ", name = "method", snippetType = "autosnippet" },
		fmt(
			[[
			func ({} {}) {}({}) {} {{
				{}
			}}
			]],
			{
				transform(1, extractCapitalLetters),
				i(1),
				i(2, "name"),
				i(3),
				i(4),
				i(5),
			}
		)
	),
	s(
		{ trig = "if~~ ", name = "if", snippetType = "autosnippet" },
		fmt(
			[[
			if {} {{
				{}
			}}
			]],
			{
				i(1),
				i(2),
			}
		)
	),
	s(
		{ trig = "elif~~ ", name = "else if", snippetType = "autosnippet" },
		fmt(
			[[
			else if {} {{
				{}
			}}
			]],
			{
				i(1),
				i(2),
			}
		)
	),
	s(
		{ trig = "else~~ ", name = "else", snippetType = "autosnippet" },
		fmt(
			[[
			else {{
				{}
			}}
			]],
			{
				i(1),
			}
		)
	),
})
