-- Setup globals that I expect to be always available.
--  See `./lua/dpp/globals.lua` for more information.
require('user.globals')

-- Setup sensible options and, also make sure to set `mapleader` before lazy
-- so your mappings are correct
require('user.opts')

-- Basic keymaps for general purpose, no any installed plugin is required,
-- that's why is loaded before lazy plugin manager
require('user.keymaps')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("user.plugins", {
    defaults = { lazy = false },
    checker = { enabled = true },
    diff = {
        cmd = "terminal_git",
    },
    performance = {
        cache = {
            enabled = true,
            -- disable_events = {},
        },
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                -- "netrwPlugin",
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin"
            },
        },
    },
    change_detection = {
        enabled = false,
        notify = false,
    },
    ui = {
        border = 'rounded',
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
        },
    },
})

require('user.autocmds')
require('user.lang.go.commands')
