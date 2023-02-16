return {
    {
        'EdenEast/nightfox.nvim',
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = 'dark'
            require('nightfox').setup({
                options = {
                    styles = {
                        comments = 'italic',
                        types = 'italic',
                    },
                },
            })
            vim.cmd('colorscheme terafox')
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#152528' })
            vim.api.nvim_set_hl(0, 'Visual', { bg = '#425e5e' })
            vim.api.nvim_set_hl(0, 'Search', { fg = '#152528', bg = '#fda47f' })
        end,
    },
    {
        'projekt0n/github-nvim-theme',
        tag = 'v0.0.7',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = 'dark'
            require('github-theme').setup({
                theme_style = 'dark',
                function_style = 'italic',
            })
        end,
    },
    {
        'Mofiqul/vscode.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = 'dark'
            require('vscode').setup({
                transparent = true,
                italic_comments = true,
            })
            -- vim.api.nvim_set_hl(0, 'Normal', { bg="#272727" })
            -- vim.api.nvim_set_hl(0, 'CursorLine', { bg="#004b72" })
        end,
    },
    {
        'mcchrish/zenbones.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
        config = function()
            -- vim.o.background='light'
            vim.o.background = 'dark'
            vim.g.zenbones = {
                colorize_diagnostic_underline_text = true,
                lightness = 'dim',
                darkness = 'warm',
            }
            vim.cmd('colorscheme rosebones')
            -- vim.cmd('colorscheme zenburned')
            -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg="#e8e4e3" })
            -- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg="#82875d"})
            -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg="#82875d", bg="#d7dbb9" })
            -- vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg="#82875d" })
            -- vim.api.nvim_set_hl(0, "DiagnositcInfo", { fg="#3387c2"})
            -- vim.api.nvim_set_hl(0, "DiagnositcVirtualTextInfo", { fg="#3387c2"})
            -- vim.api.nvim_set_hl(0, "DiagnositcSignInfo", { fg="#3387c2"})
        end,
    },
    {
        'sainnhe/gruvbox-material',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = 'light'
            vim.g.gruvbox_material_background = 'soft'
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_enable_italic = 1
            vim.cmd('colorscheme gruvbox-material')
        end,
    },
}
