-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set(
    'n',
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)
vim.keymap.set(
    'n',
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)

-- Navigate buffers
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '[B', ':bfirst<CR>', { desc = 'First buffer' })
vim.keymap.set('n', ']B', ':blast<CR>', { desc = 'Last buffer' })

-- Keymaps for better buffer splitting
vim.keymap.set(
    'n',
    '<leader>sh',
    ':leftabove vsplit<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>sl',
    ':rightbelow vsplit<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>sk',
    ':leftabove split<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>sj',
    ':rightbelow split<CR>',
    { noremap = true, silent = true }
)

-- Keymaps for better windows splitting
vim.keymap.set(
    'n',
    '<leader>wh',
    '<cmd>:topleft vsplit<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>wl',
    '<cmd>:botright vsplit<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>wk',
    '<cmd>:topleft split<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    '<leader>wj',
    '<cmd>:botright split<CR>',
    { noremap = true, silent = true }
)
