--P(vim.api.nvim_list_runtime_paths())
--P(vim.api.nvim_get_runtime_file("", true))

local run_selected = function()
	local text = vim.api.nvim_buf_get_lines(
		vim.api.nvim_get_current_buf(),
		vim.fn.getpos("'<")[2],
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

	local command = { "echo", text, "|", "dune", "utop", "./", [[--]], [[-stdin]] }
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
		end
	})
end

--vim.keymap.set.("v", "<leader>r", run_selected, {description = "Run selected code", silent = true})
