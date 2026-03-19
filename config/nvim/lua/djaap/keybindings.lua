local wk = require("which-key")
local Terminal = require("toggleterm.terminal").Terminal
require("toggleterm").setup({ shell = vim.o.shell }) -- have to put this here for some reason

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

local toggle_fns = function(fn1, fn2)
	local current = 1
	return function()
		if current == 1 then
			current = 2
			fn2()
		else
			current = 1
			fn1()
		end
	end
end

local toggle_linenum = toggle_fns(function()
	vim.cmd([[:set relativenumber]])
end, function()
	vim.cmd([[:set norelativenumber]])
end)

-------------------------------------------------------------------------------
-- Mappings (whick-key)
-------------------------------------------------------------------------------

-- Telescope
wk.add({
	-- { "<C-f>", ":Telescope git_files<cr>", desc = "Find files" },
	{
		"<C-f>",
		function()
			require("fff").find_files()
		end,
		desc = "Find files",
	},
	{ "<leader>ff", ":Telescope find_files<cr>", desc = "Find files" },
	{ "<leader>fb", ":Telescope buffers<cr>", desc = "Find buffers" },
	{ "<leader>fB", ":Telescope git_branches<cr>", desc = "Find git branches" },
	{ "<leader>fc", ":Telescope commands<cr>", desc = "Find vim commands" },
	{ "<leader>fl", ":Telescope live_grep<cr>", desc = "Grep files" },
	{ "<leader>fg", ":Telescope grep_string<cr>", desc = "Grep string" },
	{ "<leader>fh", ":Telescope help_tags<cr>", desc = "Find vim help tags" },
	{ "<leader>fi", ":Telescope builtin<cr>", desc = "Find builtin pickers" },
	{ "<leader>fn", ":Telescope neorg switch_workspace<cr>", desc = "Find Neorg workspace" },
	{ "<leader>fo", ":Telescope vim_options<cr>", desc = "Find vim options" },
	{ "<leader>fs", ":Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Find vim options" },
	{
		"<leader>fv",
		function()
			require("telescope.builtin").find_files()
		end,
		desc = "Find vim configs",
	},
})

-- navigate panes
wk.add({
	{ "<c-k>", ":wincmd k<CR>", desc = "Focus window above" },
	{ "<c-j>", ":wincmd j<CR>", desc = "Focus window below" },
	{ "<c-h>", ":wincmd h<CR>", desc = "Focus window to the left" },
	{ "<c-l>", ":wincmd l<CR>", desc = "Focus window to the right" },
	{ "<S-Up>", ":wincmd k<CR>", desc = "Focus window above" },
	{ "<S-Down>", ":wincmd j<CR>", desc = "Focus window below" },
	{ "<S-Left>", ":wincmd h<CR>", desc = "Focus window to the left" },
	{ "<S-Right>", ":wincmd l<CR>", desc = "Focus window to the right" },
	{ "<c-w><S-Up>", ":wincmd K<CR>", desc = "Focus window above" },
	{ "<c-w><S-Down>", ":wincmd J<CR>", desc = "Focus window below" },
	{ "<c-w><S-Left>", ":wincmd H<CR>", desc = "Focus window to the left" },
	{ "<c-w><S-Right>", ":wincmd L<CR>", desc = "Focus window to the right" },
})

-- tabs
wk.add({
	{ "<leader>tc", ":tabnew<CR>", desc = "Tab New" },
	{ "<leader>tn", ":tabnext<CR>", desc = "Tab Next" },
	{ "<leader>tp", ":tabprevious<CR>", desc = "Tab Previous" },
	{ "<leader>td", ":tabclose<CR>", desc = "Tab Close" },
})

-- registers
wk.add({
	{ "<leader>y", '"+y', desc = "yank into clipboard", mode = { "n", "v" } },
	{ "<leader>p", '"_dp', desc = "paste into blackhole", mode = { "n", "v" } },
})

-- quickfix
wk.add({
	{ "<c-.>", ":cnext<CR>zz", desc = "quickfix next" },
	{ "<c-,>", ":cprevious<CR>zz", desc = "quickfix previous" },
})

-- toggle settings
wk.add({
	{ "<leader>Tn", toggle_linenum, desc = "Toggle relative number" },
	{ "<leader>Ts", ":set invspell<CR>", desc = "Toggle spellcheck" },
	{ "<leader>Tw", ":set invwrap<CR>", desc = "Toggle linewrap" },
	{ "<leader>Tb", toggle_background, desc = "Toggle background" },
})

-- toggle views
wk.add({
	{ "T", ":NeoTreeRevealToggle<CR>", desc = "Toggle NeoTree" },
	{ "S", ":SymbolsOutline<CR>", desc = "Toggle SymbolsOutline" },
})

-- source file and compile
wk.add({
	{ "<leader>Lc", ":w<CR>:source %<CR>", desc = "load current file" },
	{ "<leader>Li", ":w<CR>:source ~/.config/nvim/init.lua<CR>", desc = "load init.lua" },
	{
		"<leader>Lp",
		":source ~/.config/nvim/lua/packages.lua<CR>:PackerCompile<CR>",
		desc = "load and compile packages",
	},
})

-- center screen after moving cursor
wk.add({
	{ "<c-d>", "<c-d>zz", desc = "" },
	{ "<c-u>", "<c-u>zz", desc = "" },
	{ "n", "nzz", desc = "" },
	{ "N", "Nzz", desc = "" },
})

-- buffers
wk.add({
	{ "<leader>w", ":w<cr>", desc = "Write buffer" },
	{ "<leader>W", ":wall<cr>", desc = "Write all" },
	{ "<leader>q", ":q<cr>", desc = "Close buffer" },
	{ "<leader>Q", ":qall<cr>", desc = "Close all" },
})

-- define terminals
local float_term = Terminal:new({ direction = "float" })
local tab_term = Terminal:new({ direction = "tab", shell = vim.o.shell })

-- terminal
wk.add({
	{ "<c-esc>", [[<C-\><C-n>]], desc = "Escape terminal", mode = { "t" } },
	{ "<c-k>", "<c-\\><c-n>:wincmd k<CR>", desc = "Focus window above", mode = { "t" } },
	{ "<c-j>", "<c-\\><c-n>:wincmd j<CR>", desc = "Focus window below", mode = { "t" } },
	{ "<c-h>", "<c-\\><c-n>:wincmd h<CR>", desc = "Focus window to the left", mode = { "t" } },
	{ "<c-l>", "<c-\\><c-n>:wincmd l<CR>", desc = "Focus window to the right", mode = { "t" } },
	{ "<S-Up>", "<c-\\><c-n>:wincmd k<CR>", desc = "Focus window above", mode = { "t" } },
	{ "<S-Down>", "<c-\\><c-n>:wincmd j<CR>", desc = "Focus window below", mode = { "t" } },
	{ "<S-Left>", "<c-\\><c-n>:wincmd h<CR>", desc = "Focus window to the left", mode = { "t" } },
	{ "<S-Right>", "<c-\\><c-n>:wincmd l<CR>", desc = "Focus window to the right", mode = { "t" } },
	{
		[[<c-\>]],
		function()
			tab_term:toggle()
		end,
		desc = "Toggle Tab terminal",
		mode = { "t", "n" },
	},
	{
		[[<c-t>]],
		function()
			float_term:toggle()
		end,
		desc = "Toggle float terminal",
		mode = { "t", "n" },
	},
})

-- lsp & formatting
wk.add({
	{ "<leader>lR", ":LspRestart<CR>", desc = "Restart LSP" },
	{
		"<leader>lf",
		function()
			require("conform").format()
		end,
		desc = "Format code",
	},
})

-- misc
wk.add({
	{ "<CR>", ":noh<CR><CR>", desc = "Clear hl search" },
})

-- Plugin - Structural Join
wk.add({
	{ "<leader>j", ":TSJToggle<cr>", desc = "Structural join" },
	{ "<c-BS>", "<c-w>", desc = "Structural join", mode = { "n", "v" } },
})

-- Plugin - Git
wk.add({
	{ "<leader>gc", ':G commit -am""<Left>', desc = "Add and Commit" },
	{ "<leader>gr", ":G add .<CR>:G rebase --continue", desc = "Add and continue rebase" },
	{ "<leader>ga", ":G add .<CR>", desc = "Add" },
})

-- Plugin - debug adapter
-- wk.add({
-- 	{ "<leader>Dc", dap.continue,                 desc = "Continue" },
-- 	{ "<leader>Db", dap.toggle_breakpoint,        desc = "Toggle Breakpoint" },
-- 	{ "<leader>Dn", dap.step_over,                desc = "Step Over" },
-- 	{ "<leader>Di", dap.step_into,                desc = "Step Into" },
-- 	{ "<leader>Do", dap.step_out,                 desc = "Step Out" },
-- 	{ "<leader>DC", dap.clear_breakpoints,        desc = "Clear Breakpoints" },
-- 	{ "<leader>De", dap.terminate,                desc = "Close Dap" },
-- 	{ "<leader>Dt", require("dap-go").debug_test, desc = "Debug Test" },
-- 	{ "<leader>DT", require("dapui").toggle,      desc = "Toggle UI" },
-- })

-- Plugin - Grapple
-- wk.add({
-- 	{ "<leader>m", require("grapple").toggle, desc = "Toggle tag" },
-- 	{ "<leader>n", require("grapple").cycle_forward, desc = "Next tag" },
-- 	{ "<leader>p", require("grapple").cycle_backward, desc = "Prev tag" },
-- 	{ "<leader>1", ":GrappleSelect key=1<CR>", desc = "Goto tag 1" },
-- 	{ "<leader>2", ":GrappleSelect key=2<CR>", desc = "Goto tag 2" },
-- 	{ "<leader>3", ":GrappleSelect key=3<CR>", desc = "Goto tag 3" },
-- 	{ "<leader>4", ":GrappleSelect key=4<CR>", desc = "Goto tag 4" },
-- 	{ "<leader>5", ":GrappleSelect key=5<CR>", desc = "Goto tag 5" },
-- 	{ "<leader>Gm", require("grapple").toggle, desc = "Toggle tag" },
-- 	{ "<leader>Gn", require("grapple").cycle_forward, desc = "Next tag" },
-- 	{ "<leader>Gp", require("grapple").cycle_backward, desc = "Prev tag" },
-- 	{ "<leader>Gt", ":GrapplePopup tags<CR>", desc = "Popup menu" },
-- })

--{ 'zM',        require('ufo').openAllFolds,  desc = 'Open all folds' },
--{ 'zR',        require('ufo').closeAllFolds, desc = 'Close all folds' },

-- add groups
wk.add({
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{ "<leader>G", group = "Grapple" },
	{ "<leader>T", group = "Toggle" },
	{ "<leader>t", group = "Tabs" },
	{ "<leader>L", group = "Load" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>D", group = "Debug" },
	{ "<leader>i", group = "ionic" },
})
