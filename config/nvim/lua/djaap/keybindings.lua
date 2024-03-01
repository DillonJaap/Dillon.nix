-------------------------------------------------------------------------------
-- Imports
-------------------------------------------------------------------------------
local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
	print("nvim-dap not installed!")
	return
end

-------------------------------------------------------------------------------
-- functions
-------------------------------------------------------------------------------
local function map(m, k, v, opts)
	opts = opts or { silent = true }
	vim.keymap.set(m, k, v, opts)
end


local map_legendary_item = function(item)
	if item.mode == nil then
		map('n', item[1], item[2], item.opts)
		return
	end
	for _, m in ipairs(item.mode) do
		map(m, item[1], item[2], item.opts)
	end
end


-- convert lengendary keymap to which-key keymap
local convert_keymap_to_whichkey = function(keymaps)
	local which_key_map = {}
	for i, v in ipairs(keymaps) do
		which_key_map[i] = {}
		which_key_map[i][1] = v[1]
		which_key_map[i][2] = v.description
	end
	return which_key_map
end

local join_lists = function(dst, ...)
	local args = { ... }
	for _, list in ipairs(args) do
		vim.list_extend(dst, list)
	end
end

-- Misc fns
local list_workspaces = function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local find_worktrees = function()
	require('telescope').extensions.git_worktree.git_worktrees()
end

local find_vim_configs = function()
	require('telescope.builtin').find_files()
end

local create_worktree = function()
	require('telescope').extensions.git_worktree.create_git_worktree()
end

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


local toggle_background = toggle_fns(
	function()
		vim.o.background = 'light'
		vim.cmd(':! ln -F -s ~/.config/kitty/theme.conf ~/.config/kitty/kitty-themes/gruvbox_light.conf')
	end,
	function()
		vim.o.background = 'dark'
		vim.cmd(':! ln -F -s ~/.config/kitty/theme.conf ~/.config/kitty/kitty-themes/gruvbox_dark.conf')
	end
)

local toggle_linenum = toggle_fns(
	function()
		vim.cmd [[:set relativenumber]]
	end,
	function()
		vim.cmd [[:set norelativenumber]]
	end
)

-------------------------------------------------------------------------------
-- legendary mappings
-------------------------------------------------------------------------------

local basic_keymaps = {
	-- Telescope Find
	{ '<C-f>',          ':Telescope git_files<cr>',                     description = 'Find files' },
	{ '<leader>ff',     ':Telescope find_files<cr>',                    description = 'Find files' },
	{ '<leader>fb',     ':Telescope buffers<cr>',                       description = 'Find buffers' },
	{ '<leader>fB',     ':Telescope git_branches<cr>',                  description = 'Find git branches' },
	{ '<leader>fc',     ':Telescope commands<cr>',                      description = 'Find vim commands' },
	{ '<leader>fl',     ':Telescope live_grep<cr>',                     description = 'Grep files' },
	{ '<leader>fg',     ':Telescope grep_string<cr>',                   description = 'Grep string' },
	{ '<leader>fh',     ':Telescope help_tags<cr>',                     description = 'Find vim help tags' },
	{ '<leader>fi',     ':Telescope builtin<cr>',                       description = 'Find builtin pickers' },
	{ '<leader>fk',     ':Legendary keymaps<cr>',                       description = 'Find legendary keymaps' },
	{ '<leader>fn',     ':Telescope neorg switch_workspace<cr>',        description = 'Find Neorg workspace' },
	{ '<leader>fo',     ':Telescope vim_options<cr>',                   description = 'Find vim options' },
	{ '<leader>fs',     ':Telescope lsp_dynamic_workspace_symbols<cr>', description = 'Find vim options' },
	{ '<leader>fw',     find_worktrees,                                 description = 'Find git worktrees' },
	{ '<leader>fv',     find_vim_configs,                               description = 'Find vim configs' },

	-- navigate panes
	{ '<c-k>',          ':wincmd k<CR>',                                description = 'Focus window above' },
	{ '<c-j>',          ':wincmd j<CR>',                                description = 'Focus window below' },
	{ '<c-h>',          ':wincmd h<CR>',                                description = 'Focus window to the left' },
	{ '<c-l>',          ':wincmd l<CR>',                                description = 'Focus window to the right' },
	{ '<S-Up>',         ':wincmd k<CR>',                                description = 'Focus window above' },
	{ '<S-Down>',       ':wincmd j<CR>',                                description = 'Focus window below' },
	{ '<S-Left>',       ':wincmd h<CR>',                                description = 'Focus window to the left' },
	{ '<S-Right>',      ':wincmd l<CR>',                                description = 'Focus window to the right' },
	{ '<c-w><S-Up>',    ':wincmd K<CR>',                                description = 'Focus window above' },
	{ '<c-w><S-Down>',  ':wincmd J<CR>',                                description = 'Focus window below' },
	{ '<c-w><S-Left>',  ':wincmd H<CR>',                                description = 'Focus window to the left' },
	{ '<c-w><S-Right>', ':wincmd L<CR>',                                description = 'Focus window to the right' },


	-- tabs
	{ '<leader>tc',     ':tabnew<CR>',                                  description = 'Tab New' },
	{ '<leader>tn',     ':tabnew<CR>',                                  description = 'Tab Next' },
	{ '<leader>tp',     ':tabprevious<CR>',                             description = 'Tab Previous' },
	{ '<leader>td',     ':tabclose<CR>',                                description = 'Tab Close' },

	-- toggle settings
	{ '<leader>Tn',     toggle_linenum,                                 description = 'Toggle relative number' },
	{ '<leader>Ts',     ':set invspell<CR>',                            description = 'Toggle spellcheck' },
	{ '<leader>Tw',     ':set invwrap<CR>',                             description = 'Toggle linewrap' },
	{ '<leader>Tb',     toggle_background,                              description = 'Toggle background' },

	-- toggle NeoTree
	{ 'T',              ':NeoTreeRevealToggle<CR>',                     description = 'Toggle NeoTree' },

	-- toggle SymbolsOutline
	{ 'S',              ':SymbolsOutline<CR>',                          description = 'Toggle SymbolsOutline' },

	-- clear search hl
	{ '<CR>',           ':noh<CR><CR>',                                 description = 'Clear hl search' },

	-- source file and compile
	{ '<leader>Lc',     ':w<CR>:source %<CR>',                          description = 'load current file' },
	{ '<leader>Li',     ':w<CR>:source ~/.config/nvim/init.lua<CR>',    description = 'load init.lua' },
	{
		'<leader>Lp',
		':source ~/.config/nvim/lua/packages.lua<CR>:PackerCompile<CR>',
		description = 'load and compile packages',
	},

	-- registers
	{ '<leader>y', '"+y',                        description = 'yank into clipboard',  mode = { 'n', 'v' } },
	{ '<leader>p', '"_dp',                       description = 'paste into blackhole', mode = { 'n', 'v' } },

	-- quickfix
	{ '<c-.>',     ':cnext<CR>zz',               description = 'quickfix next' },
	{ '<c-,>',     ':cprevious<CR>zz',           description = 'quickfix previous' },

	-- misc
	{ 'zM',        require('ufo').openAllFolds,  description = 'Open all folds' },
	{ 'zR',        require('ufo').closeAllFolds, description = 'Close all folds' },
	{ '<c-d>',     '<c-d>zz',                    description = '' },
	{ '<c-u>',     '<c-u>zz',                    description = '' },
	{ 'n',         'nzz',                        description = '' },
	{ 'N',         'Nzz',                        description = '' },
	{ '<leader>J', '<leader>Jzz',                description = '' },
	{ '<leader>K', '<leader>Kzz',                description = '' },
	{ '<leader>w', ':w<cr>',                     description = 'Write buffer' },
	{ '<leader>W', ':wall<cr>',                  description = 'Write all' },
	{ '<leader>q', ':q<cr>',                     description = 'Close buffer' },
	{ '<leader>Q', ':qall<cr>',                  description = 'Close all' },
	{ '<leader>j', ':TSJToggle<cr>',             description = 'Structural join' },
	{ '<c-BS>',    '<c-w>',                      description = 'Structural join',      mode = { 'n', 'v' } },
}

local Terminal = require('toggleterm.terminal').Terminal

local tab_term = Terminal:new({ direction = "tab" })
local float_term = Terminal:new({ direction = "float" })
local vert_term = Terminal:new({ direction = "vertical" })

---@diagnostic disable-next-line: unused-local
local _tab_term_toggle = function()
	tab_term:toggle()
end

local _float_term_toggle = function()
	float_term:toggle()
end

local _vert_term_toggle = function()
	vert_term:toggle()
end

local terminal_bindings = {
	{ '<c-esc>',   [[<C-\><C-n>]],             description = 'Escape terminal',           mode = { 't' } },
	{ '<c-k>',     '<c-\\><c-n>:wincmd k<CR>', description = 'Focus window above',        mode = { 't' } },
	{ '<c-j>',     '<c-\\><c-n>:wincmd j<CR>', description = 'Focus window below',        mode = { 't' } },
	{ '<c-h>',     '<c-\\><c-n>:wincmd h<CR>', description = 'Focus window to the left',  mode = { 't' } },
	{ '<c-l>',     '<c-\\><c-n>:wincmd l<CR>', description = 'Focus window to the right', mode = { 't' } },
	{ '<S-Up>',    '<c-\\><c-n>:wincmd k<CR>', description = 'Focus window above',        mode = { 't' } },
	{ '<S-Down>',  '<c-\\><c-n>:wincmd j<CR>', description = 'Focus window below',        mode = { 't' } },
	{ '<S-Left>',  '<c-\\><c-n>:wincmd h<CR>', description = 'Focus window to the left',  mode = { 't' } },
	{ '<S-Right>', '<c-\\><c-n>:wincmd l<CR>', description = 'Focus window to the right', mode = { 't' } },
	{ [[<c-\>]],   _tab_term_toggle,           description = 'Toggle Tab terminal',       mode = { 't', 'n' } },
	{ [[<c-t>]],   _float_term_toggle,         description = 'Toggle float terminal',     mode = { 't', 'n' } },
}

local git_keymaps = {
	{ '<leader>gw', create_worktree,                    description = 'Create git worktree' },
	{ '<leader>gc', ':G commit -am""<Left>',            description = 'Add and Commit' },
	{ '<leader>gr', ':G add .<CR>:G rebase --continue', description = 'Add and continue rebase' },
	{ '<leader>ga', ':G add .<CR>',                     description = 'Add' },
}

local lsp_keymaps = {
	-- commands
	{ '<leader>lR', ':LspRestart<CR>', description = 'Restart LSP' },
}

-- TODO fix these mappings
local snippet_keymaps = {
	--	{
	--		'<Tab>',
	--		[[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']],
	--		description = 'luasnip next item',
	--		mode = { 'i' },
	--		opts = { noremap = false, silent = true },
	--		hide = true,
	--	},
	--{
	--	'<S-Tab>',
	--	[[<cmd>lua require'luasnip'.jump(-1)<Cr>]],
	--	description = 'luasnip prev item',
	--	mode = { 'i', 's' },
	--	opts = { noremap = true, silent = true }
	--},
	--{
	--	'<Tab>',
	--	[[<cmd>lua require'luasnip'.jump(1)<Cr>]],
	--	description = 'luasnip next item',
	--	mode = { 'i' },
	--	opts = { noremap = true, silent = true }
	--},
}

local dap_keymaps = {
	{ '<leader>Dc', dap.continue,                 description = 'Continue' },
	{ '<leader>Db', dap.toggle_breakpoint,        description = 'Toggle Breakpoint' },
	{ '<leader>Dn', dap.step_over,                description = 'Step Over' },
	{ '<leader>Di', dap.step_into,                description = 'Step Into' },
	{ '<leader>Do', dap.step_out,                 description = 'Step Out' },
	{ '<leader>DC', dap.clear_breakpoints,        description = 'Clear Breakpoints' },
	{ '<leader>De', dap.terminate,                description = 'Close Dap' },
	{ '<leader>Dt', require('dap-go').debug_test, description = 'Debug Test' },
	{ '<leader>DT', require('dapui').toggle,      description = 'Toggle UI' },
}

local grapple_keymaps = {
	{ '<leader>m',  require('grapple').toggle,         description = 'Toggle tag' },
	{ '<leader>n',  require('grapple').cycle_forward,  description = 'Next tag' },
	{ '<leader>p',  require('grapple').cycle_backward, description = 'Prev tag' },
	{ '<leader>1',  ':GrappleSelect key=1<CR>',        description = 'Goto tag 1' },
	{ '<leader>2',  ':GrappleSelect key=2<CR>',        description = 'Goto tag 2' },
	{ '<leader>3',  ':GrappleSelect key=3<CR>',        description = 'Goto tag 3' },
	{ '<leader>4',  ':GrappleSelect key=4<CR>',        description = 'Goto tag 4' },
	{ '<leader>5',  ':GrappleSelect key=5<CR>',        description = 'Goto tag 5' },
	{ '<leader>Gm', require('grapple').toggle,         description = 'Toggle tag' },
	{ '<leader>Gn', require('grapple').cycle_forward,  description = 'Next tag' },
	{ '<leader>Gp', require('grapple').cycle_backward, description = 'Prev tag' },
	{ '<leader>Gt', ':GrapplePopup tags<CR>',          description = 'Popup menu' },
}

local keymaps = {}
join_lists(
	keymaps,
	basic_keymaps,
	terminal_bindings,
	lsp_keymaps,
	snippet_keymaps,
	dap_keymaps,
	grapple_keymaps,
	git_keymaps
--convert_to_empty_keymap(lsp_keymaps),
)

-------------------------------------------------------------------------------
-- register keymaps
-------------------------------------------------------------------------------

require('legendary').setup({
	keymaps = keymaps,
	commands = {
		-- easily create user commands
		{ ':SayHello', function() print('hello world!') end, description = 'Say hello as a command' },
	},
	autocmds = {
		{
			'FileType',
			function()
				map('n', '<leader>im', ':Neorg inject-metadata<CR>')
				map('n', '<c-m>', ':TZAtaraxis<CR>')
			end,
			opts = {
				pattern = { 'norg' }
			}
		}
		-- Create autocmds and augroups
		--{ 'BufWritePre', vim.lsp.buf.format, description = 'Format on save' },
		--{
		--name = 'MyAugroup',
		--clear = true,
		-- autocmds here
		--},
	},
	funcs = {
		-- Make arbitrary Lua functions that can be executed via the item finder
		-- { function() doSomeStuff() end, description = 'Do some stuff with a Lua function!' },
	},
})

require('which-key').register({
	convert_keymap_to_whichkey(keymaps),
	["<leader>"] = {
		f = { name = "Find" },
		g = { name = "Git" },
		G = { name = "Grapple" },
		t = { name = "Toggle" },
		L = { name = "Load" },
		l = { name = "LSP" },
		D = { name = "Debug" },
	},
})

-------------------------------------------------------------------------------
-- exports
-------------------------------------------------------------------------------

local M = {
	basic_keymaps = basic_keymaps,
	lsp_keymaps = lsp_keymaps,
	map_key = map_legendary_item,
	register_which_keys = function()
		require('which-key').register({
			convert_keymap_to_whichkey(lsp_keymaps),
		})
	end
}

return M
