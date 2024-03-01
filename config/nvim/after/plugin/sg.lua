local bufread = require("sg.bufread")

vim.api.nvim_create_autocmd("BufReadCmd", {
	group = vim.api.nvim_create_augroup("sourcegraph-bufread", { clear = true }),
	pattern = { "sg://*", "https://sourcegraph.com/*", "https://ciorg.sourcegraphcloud.com/*" },
	callback = function(event)
		bufread.edit(event.buf or vim.api.nvim_get_current_buf(), vim.fn.expand "<amatch>" --[[@as string]])
	end,
	desc = "Sourcegraph link and protocol handler",
})
