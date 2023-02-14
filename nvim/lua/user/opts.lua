--[[ opt.lua ]]
local opt = vim.opt

-- [[ General ]]
--
vim.g.mapleader = ' ' -- Leader key
--opt.guicursor = 'i:block' -- Block cursor always

vim.opt.updatetime=300 -- 300ms of no cursor movement to trigger CursorHold
vim.opt.clipboard = "unnamedplus"


-- [[ UI ]]
--
opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.cmdheight = 0
opt.cursorline = true
opt.incsearch = false
opt.colorcolumn = "80"
-- opt.scrolloff = 999
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = 'yes'
opt.syntax = "ON"
opt.termguicolors = true
vim.g.t_Co = 256
-- opt.guicursor = {
--   "n-v-c:block-Cursor/lCursor",
--   -- "i-ci-ve:ver30-Cursor-blinkwait300-blinkon200-blinkoff150",
--   "i-ci-ve:ver30-Cursor",
--   "r-cr:hor20",
--   "o:hor50",
-- }

-- [[ Backup ]]
--
opt.swapfile = true
opt.undofile = true
opt.undodir = vim.fn.stdpath 'data' .. "undodir"

--  [[ Neovide ]]
--
if vim.g.neovide then
	vim.cmd([[
	  set guifont=JetbrainsMono\ Nerd\ Font:h14:i:#e-subpixelantialias:#h-slight
	]])
	vim.g.neovide_floating_opacity = 1
	vim.g.neovide_cursor_animation_length = 0.05
	-- vim.g.neovide_cursor_trail_size = 1
	vim.cmd 'let g:neovide_remember_window_size = v:true'
	vim.cmd 'let g:neovide_hide_mouse_when_typing = v:true'
end
