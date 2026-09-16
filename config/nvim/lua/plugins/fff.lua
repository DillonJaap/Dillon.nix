return {
	"dmtrKovalenko/fff.nvim",
	-- Pinned to a stable tag. Bumping this triggers a binary rebuild via the
	-- version-aware guard below. Tracking "*"/main previously left the native
	-- library stale against updated Lua, producing nil item.path crashes.
	version = "v0.10.6",
	enabled = true,
	build = function()
		-- Rebuild the native binary only when the checked-out plugin version
		-- differs from the one that produced the current binary. fff's plain
		-- "binary exists?" download guard cannot detect an ABI mismatch, so we
		-- stamp the built HEAD next to the binary and compare against it.
		local dl = require("fff.download")
		local binary_path = dl.get_binary_path()
		-- binary lives at <plugin>/target/release/<lib>; go up to the plugin root
		-- so git runs in the repo regardless of Neovim's current directory.
		local plugin_dir = vim.fn.fnamemodify(binary_path, ":h:h:h")
		local stamp_path = vim.fn.fnamemodify(binary_path, ":h") .. "/.fff-built-version"

		local current = vim.fn
			.system({ "git", "-C", plugin_dir, "rev-parse", "HEAD" })
			:gsub("%s+", "")
		local built = ""
		if vim.fn.filereadable(stamp_path) == 1 then
			built = (vim.fn.readfile(stamp_path)[1] or ""):gsub("%s+", "")
		end

		-- Up to date: correct binary present and version matches.
		if vim.fn.filereadable(binary_path) == 1 and current ~= "" and built == current then
			return
		end

		dl.download_or_build_binary()

		-- Record the version we just built so future updates can detect drift.
		if vim.fn.filereadable(binary_path) == 1 and current ~= "" then
			vim.fn.writefile({ current }, stamp_path)
		end
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
