vim.api.nvim_set_keymap('n', '<leader>r', ':luafile %<cr>', { desc = "run current file" })
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = -1 -- If negative, shiftwidth value is used


local run_selected = function()
	local text = vim.api.nvim_buf_get_lines(
		vim.api.nvim_get_current_buf(),
		vim.fn.getpos("'<")[2] - 1,
		vim.fn.getpos("'>")[2],
		false
	)

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufnr, true, {
		relative = "win",
		row = 4,
		col = 4,
		width = vim.api.nvim_win_get_width(0) - 10,
		height = vim.api.nvim_win_get_height(0) - 10,
		border = "double"
	})


	local code = vim.fn.join(text, "\n")

	local file = io.open("/tmp/script.lua", "w")
	_, err = file:write(code)
	if err ~= nil then
		print("err not nil ", err)
		return
	end
	file:close()

	print("test")

	local command = { 'nvim', '-l', '/tmp/script.lua' }
	local data = vim.fn.system(command)
	vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "output:" })
	vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { data })
end

vim.keymap.set("v", "<leader>x", run_selected, {
	silent = false,
})

Run_select = run_selected
