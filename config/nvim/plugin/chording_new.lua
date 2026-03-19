--[[
--local socket = require("socket")
local break_chars = { "(", ")", "}", "{" }

-- Table to hold valid identifier characters
local non_breaking_chars = { " " }

-- Add all uppercase letters
for char = 65, 90 do
	table.insert(non_breaking_chars, string.char(char))
end

-- Add all lowercase letters
for char = 97, 122 do
	table.insert(non_breaking_chars, string.char(char))
end

-- Add digits
for digit = 48, 57 do
	table.insert(non_breaking_chars, string.char(digit))
end

local exit_insert = function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
end

local enter_insert = function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("a", true, false, true), 'n', true)
end

local snake_case = function(text)
	local split_text = vim.split(vim.trim(text), " ", {})
	return table.concat(split_text, "_")
end

local start_pos = { 0, 0 }
local start_pos_set = false

--vim.cmd [ [hi MyHighlightGroup guibg=yellow guifg=black ctermbg=226 ctermfg=16] ]
local ns_id = vim.api.nvim_create_namespace('MyHighlights')
vim.api.nvim_buf_add_highlight(0, ns_id, 'MyHighlightGroup', 1, 0, -1)


local get_inserted_text = function()
	local cur_pos = vim.api.nvim_win_get_cursor(0)
	print(vim.inspect({ start_pos, cur_pos}))
	vim.api.nvim_buf_add_highlight(0, ns_id, 'MyHighlightGroup', start_pos[1], start_pos[2], cur_pos[2])

	if not vim.tbl_contains(non_breaking_chars, vim.v.char) then
		start_pos = vim.api.nvim_win_get_cursor(0)
		start_pos_set = false

		vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
		return
	end
end

vim.keymap.set("i", "<C-'>", function()
	if not start_pos_set then
		start_pos = vim.api.nvim_win_get_cursor(0)
		start_pos_set = true
		return
	end

	local end_pos = vim.api.nvim_win_get_cursor(0)
	exit_insert()

	local lines = vim.api.nvim_buf_get_text(
		0,
		start_pos[1] - 1,
		start_pos[2],
		end_pos[1] - 1,
		end_pos[2],
		{}
	)
	local text = table.concat(lines, "")

	-- TODO keep leading whitespace
	text = snake_case(text)

	vim.api.nvim_buf_set_text(
		0,
		start_pos[1] - 1,
		start_pos[2],
		end_pos[1] - 1,
		end_pos[2],
		{}
	)
	vim.api.nvim_put({ text }, "c", false, true)


	start_pos = vim.api.nvim_win_get_cursor(0)
	start_pos_set = false
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
	enter_insert()
end, { silent = false })

local chording_augroup = vim.api.nvim_create_augroup('chording', { clear = true })
vim.api.nvim_create_autocmd('InsertCharPre', {
	group = chording_augroup,
	callback = get_inserted_text
})

local break_group = vim.api.nvim_create_augroup('chording', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
	group = break_group,
	callback = function()
		start_pos = vim.api.nvim_win_get_cursor(0)
		start_pos_set = false
	end
})
--]]
