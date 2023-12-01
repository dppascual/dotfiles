if vim.loader then
    vim.loader.enable()
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if vim.g.neovide then
    vim.opt.linespace = 3
    vim.g.neovide_scale_factor = 1.1
    vim.o.guifont = 'Jetbrains Mono:h15'
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true
    vim.g.neovide_cursor_animation_length = 0.08
    vim.g.neovide_cursor_trail_size = 0.3
end

require('user.config.globals')
require('user.config.keymaps')
require('user.config.options')
require('user.config.autocmds')
require('user.plugins')
