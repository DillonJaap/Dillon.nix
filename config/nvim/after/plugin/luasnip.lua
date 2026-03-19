local ls = require("luasnip")
local collection = require("luasnip.session.snippet_collection")
local types = require("luasnip.util.types")

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

require("djaap.snippets.go")
require("djaap.snippets.lua")

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
				i(2),
			}
		)
	),
})

--------------------------------------------------------------------------------
-- Vue Snippets
--------------------------------------------------------------------------------
collection.clear_snippets("vue")

ls.add_snippets("vue", {
	s(
		{ trig = "ionaccordion ", name = "ionic accordion with lable", snippetType = "autosnippet" },
		fmt(
			[[
				<ion-accordion value="{1}">
					<ion-item slot="header" color="light">
						<ion-label>{2}</ion-label>
					</ion-item>

					<ion-list slot="content" class="ion-padding">
						{3}
					</ion-list>
				</ion-accordion>
			]], -- don't include the closing parenthesis because a plugin provides it
			{
				i(1),
				i(2),
				i(3),
			}
		)
	),
})

--------------------------------------------------------------------------------
-- Key Mappings
--------------------------------------------------------------------------------

require("which-key").add({
	{
		{
			"<S-Left>",
			function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end,
			desc = "snippet: jump prev",
			mode = { "i", "s" },
		},
		{
			"<S-Right>",
			function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end,
			desc = "snippet: expand or jump",
			mode = { "i", "s" },
		},
		{
			"<c-k>",
			function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end,
			desc = "snippet: expand or jump",
			mode = { "i", "s" },
		},
		{
			"<c-l>",
			function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end,
			desc = "snippet: jump prev",
			mode = { "i", "s" },
		},
		{
			"<c-m>",
			function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end,
			desc = "snippet: jump prev",
		},
		mode = { "i", "s" },
	},
	{
		"<leader>LS",
		"<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
		desc = "source luasnip cfg",
	},
})
