local ls = require("luasnip")
local collection = require("luasnip.session.snippet_collection")
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

local ts_locals = require("nvim-treesitter.locals")
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
	table.insert(nodes, sn(nil, fmt('fmt.Errorf("{}: %w", {})', { i(1), t(err) })))
	table.insert(nodes, sn(nil, fmt('fmt.Errorf("%w: %w", {}, {})', { i(1), t(err) })))
	return c(1, nodes)
end

local node_from_tsnode = function(type, info)
	local zero_values = {
		int = "0",
		string = '""',
		bool = "false",
		error = error_node(info["error_name"]),
	}
	zero_values["*"] = "nil"
	zero_values["[]"] = "nil"

	local zero_val = zero_values[type]
	if zero_val == nil then
		return t(type .. "{}")
	end

	return t(zero_val)
end

--- nodes_from_tsnode
--- @param node TSNode
--- @param info any
--- @return table
local nodes_from_tsnode = function(node, info)
	if node:type() ~= "parameter_list" then
		return { node_from_tsnode(get_tsnode_text(node, 0), info) }
	end

	local tbl = {}
	local pos = 0
	for n in node:iter_children() do
		if n:named() then
			table.insert(tbl, node_from_tsnode(get_tsnode_text(n, 0), info))
			table.insert(tbl, t(", "))
			pos = pos + 1
		end
	end
	table.remove(tbl)
	return tbl
end

local get_return_nodes = function(info)
	local query = vim.treesitter.query.parse(
		"go",
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
		if v:type() == "function_declaration" or v:type() == "func_literal" or v:type() == "method_declaration" then
			function_node = v
			break
		end
	end
	-- local file = io.open("output.txt", "w")
	-- if file then
	-- 	if function_node == nil then
	-- 		file:write("function node nil")
	-- 	end
	-- 	file:write("function node not nil")
	-- end
	-- file:close()

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
-- snippets
-------------------------------------------------------------------------------
ls.add_snippets("go", {
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
					fmt(
						[[
					name string
					wantErr error{1}
					]],
						i(1)
					),
					t(""),
				}),
				c(3, {
					fmt(
						[[
					name: "Success",
					wantErr: nil,{}
					]],
						i(1)
					),
					t(""),
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
	-------------------------------------------------------------------------------
	-- CharaChorder snippets
	-------------------------------------------------------------------------------
	s(
		{ trig = "function snippet", name = "function snip", snippetType = "autosnippet" },
		fmt(
			[[
			func {name}({parameters}) {return_}{{
				{body}
			}}
			{exit}
			]],
			{
				name = i(1, "name"),
				parameters = i(2),
				return_ = i(3),
				body = i(4),
				exit = i(5),
			}
		)
	),
	s(
		{ trig = "method snippet", name = "method", snippetType = "autosnippet" },
		fmt(
			[[
			func ({} {}) {}({}) {}{{
				{}
			}}
				{}
			]],
			{
				transform(1, extractCapitalLetters),
				i(1),
				i(2, "name"),
				i(3),
				i(4),
				i(5),
				i(6),
			}
		)
	),
	s(
		{ trig = "for snippet", name = "for", snippetType = "autosnippet" },
		fmt(
			[[
			for {iter}; {cond}; {update} {{
				{body}
			}}{exit}
			]],
			{
				iter = i(1, "i := 0"),
				cond = i(2, "i < 10"),
				update = i(3, "i++"),
				body = i(4),
				exit = i(5),
			}
		)
	),
	s(
		{ trig = "while snippet", name = "while", snippetType = "autosnippet" },
		fmt(
			[[
			for {cond} {{
				{body}
			}}{exit}
			]],
			{
				cond = i(1, ""),
				body = i(2),
				exit = i(3),
			}
		)
	),
	s(
		{ trig = "range snippet", name = "for range", snippetType = "autosnippet" },
		fmt(
			[[
			for {key}, {value} := range {var} {{
				{body}
			}}{exit}
			]],
			{
				key = i(1, "k"),
				value = i(2, "v"),
				var = i(3, "var"),
				body = i(4),
				exit = i(5),
			}
		)
	),
	s(
		{ trig = "if snippet", name = "if", snippetType = "autosnippet" },
		fmt(
			[[
			if {cond} {{
				{body}
			}}
			]],
			{
				cond = i(1),
				body = i(2),
			}
		)
	),
	s(
		{ trig = "else if snippet", name = "else if", snippetType = "autosnippet" },
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
		{ trig = "else snippet", name = "else", snippetType = "autosnippet" },
		fmt(
			[[
			else {{
				{body}
			}}{exit}
			]],
			{
				body = i(1),
				exit = i(2),
			}
		)
	),
	s(
		{ trig = "if error", name = "if err != nil", snippetType = "autosnippet" },
		fmt(
			[[
			if {1} != nil {{
				return {2}
			}}
			]],
			{
				i(1, "err"),
				c(1, {
					fmt([[{}]], i(1, "err")),
					fmt([["{}", {}]], { i(1), i(2, "err") }),
				}),
				-- TODO update this to be dynamic
			}
		)
	),
	s(
		{ trig = "struct snippet", name = "struct", snippetType = "autosnippet" },
		fmt(
			[[
			type {} struct {{
				{}
			}}
			{}
			]],
			{
				i(1),
				i(2),
				i(3),
			}
		)
	),
	s(
		{ trig = "interface snippet", name = "interface", snippetType = "autosnippet" },
		fmt(
			[[
			type {} interface {{
				{}
			}}
			{}
			]],
			{
				i(1),
				i(2),
				i(3),
			}
		)
	),
	s(
		{ trig = "fmt error", name = "Errorf", snippetType = "autosnippet" },
		fmt(
			[[
			fmt.Errorf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "test error", name = "test Errorf", snippetType = "autosnippet" },
		fmt(
			[[
			t.Errorf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "test fatal", name = "test Fatalf", snippetType = "autosnippet" },
		fmt(
			[[
			t.Fatalf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "fmt print", name = "Printf", snippetType = "autosnippet" },
		fmt(
			[[
			fmt.Printf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "fmt string", name = "Sprintf", snippetType = "autosnippet" },
		fmt(
			[[
			fmt.Sprintf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "fmt file", name = "Fprintf", snippetType = "autosnippet" },
		fmt(
			[[
			fmt.fprintf({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
	s(
		{ trig = "print line", name = "Println", snippetType = "autosnippet" },
		fmt(
			[[
			fmt.Println({}){}
			]],
			{
				c(1, {
					fmt([["{}", {}]], { i(1), i(2) }),
					fmt([["{}"]], i(1)),
				}),
				i(2),
			}
		)
	),
})
