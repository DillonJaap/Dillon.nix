--[[
--local socket = require("socket")
--local break_chars = { " ", "<BS>", "<Tab>", "<CR>" }
local break_chars = { " ", "<BS>", "<Tab>", "<CR>" }

-- Table to hold valid identifier characters
local identifier_chars = {}

-- Add all uppercase letters
for char = 65, 90 do
	table.insert(identifier_chars, string.char(char))
end

-- Add all lowercase letters
for char = 97, 122 do
	table.insert(identifier_chars, string.char(char))
end

-- Add digits
for digit = 48, 57 do
	table.insert(identifier_chars, string.char(digit))
end

-- Add underscore
table.insert(identifier_chars, "_")

local snake_case_word = function()
	vim.api.nvim_input("_")
end

local transform_word = {
	none = function() end,
	snake = snake_case_word
}

--- Calculate the number of characters typed per second.
--- @param chars string: The string of characters to measure.
--- @param start number: The start time in seconds.
--- @param end_ number: The end time in seconds.
--- @return number: The number of characters per second.
-- TODO_need milisecond input
local characters_per_second = function(chars, start, end_)
	if end_ <= start then
		return 0
	end

	local duration = end_ - start
	local char_count = #chars
	return char_count / duration
end

local delete_space = function()
	local last_char = 'a'  -- the last character that was typed
	local penult_char = 'a' -- the second to last character that was typed

	-- the last word that was typed
	local last_word = {
		text = "",
		is_chord = false
	}

	local timer = {
		started = false,
		start = 1,
		end_ = 2
	}

	return function()
		penult_char = last_char
		last_char = vim.v.char

		local file1 = io.open("test.txt", "a")
		last_word.text = last_word.text .. last_char

		local is_ident = vim.tbl_contains(identifier_chars, last_char)
		local pen_is_ident = vim.tbl_contains(identifier_chars, penult_char)

		-- if we hit a character that breaks a chord then update the word
		if not is_ident then
			--timer.end_ = socket.gettime()
			timer.started = false

			if last_char == ' ' and pen_is_ident then
				last_word.is_chord = (characters_per_second(last_word.text, timer.start, timer.end_) == 0)
				--last_word.is_chord = true
				return
			end

			last_word.is_chord = false
			return
		end

		if not timer.started then
			timer.started = true
			--timer.start = socket.gettime()
		end

		if last_word.is_chord and penult_char == " " then
			--vim.api.nvim_input("<Left>")
			--vim.api.nvim_input("<BS>")
			--transform_word["snake"]()
			--vim.api.nvim_input("<Right>")

			last_word.text = ""
			last_word.is_chord = false
		end
	end
end

--local chording_augroup = vim.api.nvim_create_augroup('chording', { clear = true })
--vim.api.nvim_create_autocmd('InsertCharPre', {
--group = chording_augroup,
--callback = delete_space()
--})
--]]
