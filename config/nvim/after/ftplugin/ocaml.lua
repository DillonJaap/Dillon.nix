local run_selected = function()
	local text = vim.api.nvim_buf_get_lines(
		vim.api.nvim_get_current_buf(),
		vim.fn.getpos("'<")[2] - 1,
		vim.fn.getpos("'>")[2],
		false
	)

	local code = vim.fn.join(text, "\n")

	local file = io.open("/tmp/script.ml", "w")
	_, err = file:write(code)
	file:close()


	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufnr, true, {
		relative = "win",
		row = 9,
		col = 9,
		width = vim.api.nvim_win_get_width(0) - 20,
		height = vim.api.nvim_win_get_height(0) - 20,
		border = "double"
	})

	vim.fn.jobstart('dune utop ./ -- /tmp/script.ml > /tmp/output', {
		on_exit = function(_, _)
			local data = vim.fn.system({ 'cat', '/tmp/output' })
			local lines = vim.split(data, "\n")
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
		end,
	})
end

vim.keymap.set("v", "<leader>x", run_selected, {
	silent = false,
})


vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = -1 -- If negative, shiftwidth value is used
