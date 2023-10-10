if vim.loader then
    vim.loader.enable()
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('user.config.globals')
require('user.config.keymaps')
require('user.config.options')
require('user.config.autocmds')
require('user.plugins')
