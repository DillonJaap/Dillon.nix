P = function(v)
	print(vim.inspect(v))
	return v
end



--[[	
Map_key = function(keymap)
	local mode = keymap.mode or "n"
	local opts = {
		"desc" = keymap.desc
	}
	vim.api.nvim_set_keymap(mode, keymap[1], keymap[2], opts)
end
--]]
