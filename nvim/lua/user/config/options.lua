-- [[ SETTINGS ]]
--
vim.g.mapleader = ' ' -- Leader key
vim.g.maplocalleader = ' '

-- [[ GENERAL ]]
--
-- vim.opt.hidden = true
vim.opt.showmatch = true -- Highlight matching parenthesis
vim.opt.matchtime = 3 -- Tenths of a second to show the matching paren
vim.opt.splitright = true -- Split windows right to the current windows
vim.opt.splitbelow = true -- Split windows below to the current windows
vim.opt.splitkeep = 'cursor'
vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

vim.opt.clipboard = 'unnamedplus' -- Copy/paste to system clipboard
vim.opt.ignorecase = true -- Search case insensitive...
vim.opt.smartcase = true -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options
vim.opt.updatetime = 100 -- 100ms of no cursor movement to trigger CursorHold

-- [[ UI-related options ]]
--
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative number lines
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 0 -- Hide command line
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = '80'
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.smoothscroll = true
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
vim.opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
}

-- Colors
--
vim.opt.termguicolors = true

-- Folding
vim.opt.foldlevel = 99
-- vim.opt.foldtext = "v:lua.require'lazyvim.util.ui'.foldtext()"

-- if vim.fn.has('nvim-0.9.0') == 1 then
--     vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util.ui'.statuscolumn()]]
-- end

-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
if vim.fn.has('nvim-0.10') == 1 then
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
else
    vim.opt.foldmethod = 'indent'
end

-- [[ Indent ]]
--
vim.opt.expandtab = true -- expand tabs into spaces
vim.opt.shiftwidth = 4 -- number of spaces to use for each step of indent.
vim.opt.softtabstop = 4
vim.opt.tabstop = 2 -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.wrap = false

-- [[ Git ]]
--
-- Improve diff mode (https://github.com/neovim/neovim/pull/14537)
vim.opt.diffopt = table.concat({
    'algorithm:histogram',
    'internal',
    'indent-heuristic',
    'filler',
    'closeoff',
    'vertical',
    'linematch:100',
}, ',')

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

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
