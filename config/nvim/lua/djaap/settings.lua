local g = vim.g
local o = vim.o

-- Colorscheme
o.syntax = "enable"
o.background = "dark"
o.termguicolors = true
vim.cmd([[let g:gruvbox_material_background = 'hard']])
vim.cmd("colorscheme gruvbox-material")

-- Misc Visuals
o.cursorline = true
o.showcmd = true
o.title = true

-- Line Numbers
o.relativenumber = true
o.number = true

-- Splits
o.splitright = true
o.splitbelow = true

-- Searching
o.hlsearch = true
o.incsearch = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Text Wrapping
o.wrap = true
o.textwidth = 120

-- Buffers
o.hidden = true

-- Persistent Undo
o.undofile = true
vim.cmd("set undodir=$HOME/.vim/undo")
o.undolevels = 1000
o.undoreload = 10000

-- Folds
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- mouse
if vim.fn.has("mouse") == 1 then
	o.mouse = "a"
end

-- Finding files
o.path = "+=**"
o.wildmenu = true
-- o.wildcharm = '<C-z>'

-- Better editing experience
o.expandtab = false
o.smarttab = true
o.cindent = true
o.autoindent = true

o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1 -- If negative, shiftwidth value is used
--o.listchars = true
--o.listchars = 'tab: '

-- conceal level
o.conceallevel = 2

-- Sessions
Session_dir = "~/Sessions"

vim.filetype.add({
	extension = {
		cls = "apex",
		apex = "apex",
		trigger = "apex",
		soql = "soql",
		sosl = "sosl",
	},
})

-- term settings
if vim.fn.executable("nu") == 1 then
	vim.o.shell = "nu"
else
	vim.o.shell = "/bin/bash"
end

--------------------------------------------------------------------------------
-- Auto Groups -----------------------------------------------------------------
--------------------------------------------------------------------------------
local hs_augroup = vim.api.nvim_create_augroup("hs_cmds", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = ".*\\.hs",
	group = hs_augroup,
	callback = function()
		o.textwidth = 100
		o.expandtab = true
		o.tabstop = 4
		o.shiftwidth = 4
		o.softtabstop = -1 -- If negative, shiftwidth value is used
	end,
})

local term_augroup = vim.api.nvim_create_augroup("term_cmds", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	group = term_augroup,
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
	end,
})

-- other stuff
