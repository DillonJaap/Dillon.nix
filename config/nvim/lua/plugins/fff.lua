return {
	"dmtrKovalenko/fff.nvim",
	version = "*",
	enabled = true,
	build = function()
		-- Skip the blocking download/build when the binary already exists.
		-- fff.download_or_build_binary forces redownload (opts.force=true)
		-- and parks the editor for up to 2 min via vim.wait on every Lazy
		-- update of fff, which looks like a UI freeze. Skip when binary present;
		-- run :Lazy build fff.nvim manually to force-refresh.
		local dl = require("fff.download")
		if vim.fn.filereadable(dl.get_binary_path()) == 1 then return end
		dl.download_or_build_binary()
	end,
	-- if you are using nixos
	-- build = "nix run .#release",
	opts = { -- (optional)
		debug = {
			enabled = false,
			show_scores = false,
		},
	},
	-- Load during startup.
	lazy = false,
	keys = {
		-- 	{
		-- 		"ff", -- try it if you didn't it is a banger keybinding for a picker
		-- 		function()
		-- 			require("fff").find_files()
		-- 		end,
		-- 		desc = "FFFind files",
		-- 	},
	},
}
