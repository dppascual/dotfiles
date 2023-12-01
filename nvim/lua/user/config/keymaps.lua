-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
        opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- better up/down
map(
    { 'n', 'x' },
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)
map(
    { 'n', 'x' },
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)

-- Emacs motion on insert mode.
--
map(
    'i',
    '<C-a>',
    '<esc>I',
    { desc = 'Move cursor to the beginning of the line' }
)
map('i', '<C-e>', '<esc>A', { desc = 'Move cursor to the end of the line' })

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map(
    'n',
    '<C-Left>',
    '<cmd>vertical resize -2<cr>',
    { desc = 'Decrease window width' }
)
map(
    'n',
    '<C-Right>',
    '<cmd>vertical resize +2<cr>',
    { desc = 'Increase window width' }
)

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map(
    'n',
    'n',
    "'Nn'[v:searchforward]",
    { expr = true, desc = 'Next search result' }
)
map(
    'x',
    'n',
    "'Nn'[v:searchforward]",
    { expr = true, desc = 'Next search result' }
)
map(
    'o',
    'n',
    "'Nn'[v:searchforward]",
    { expr = true, desc = 'Next search result' }
)
map(
    'n',
    'N',
    "'nN'[v:searchforward]",
    { expr = true, desc = 'Prev search result' }
)
map(
    'x',
    'N',
    "'nN'[v:searchforward]",
    { expr = true, desc = 'Prev search result' }
)
map(
    'o',
    'N',
    "'nN'[v:searchforward]",
    { expr = true, desc = 'Prev search result' }
)
