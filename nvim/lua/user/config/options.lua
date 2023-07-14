-- [[ SETTINGS ]]
--
vim.g.mapleader = ' ' -- Leader key
vim.g.maplocalleader = ' '

-- [[ GENERAL ]]
--
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true
vim.opt.showmatch = true -- Highlight matching parenthesis
vim.opt.splitright = true -- Split windows right to the current windows
vim.opt.splitbelow = true -- Split windows below to the current windows

vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not it begins with upper case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options
vim.opt.updatetime = 50 -- 300ms of no cursor movement to trigger CursorHold

vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.cursorline = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = '80'
vim.opt.scrolloff = 8
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = 'yes'

-- [[ Indent ]]
--
vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of indent.
vim.opt.softtabstop = 4
vim.opt.tabstop = 2 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = false

-- [[ Colors ]]
--
vim.opt.termguicolors = true

-- [[ Backup ]]
--
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'

-- [[ Netrw ]]
--
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_winsize = 25
-- vim.g.netrw_banner = 0
-- vim.g.netrw_keepdir = 0 -- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
-- vim.g.netrw_sort_sequence = [[[\/]$,*]] -- Show directories first (sorting)
