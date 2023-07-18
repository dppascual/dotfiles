return {
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                disable_float_background = true,
            })
            vim.cmd.colorscheme('rose-pine')

            local hl = vim.api.nvim_set_hl
            hl(0, 'Constant', { fg = '#bc9493' })
            hl(0, 'String', { fg = '#bc9493' })
            hl(0, 'Number', { fg = '#bc9493' })
            hl(0, 'Identifier', { fg = '#cab0af' })
            -- hl(0, 'Keyword', { fg = '#515e58' })
        end,
    },
    {
        'rebelot/kanagawa.nvim',
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = 'dark'
            require('kanagawa').setup({
                compile = true,
                commentStyle = { italic = true },
                transparent = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = 'none',
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        NormalFloat = { bg = 'none' },
                        FloatBorder = { bg = 'none' },
                        FloatTitle = { bg = 'none' },

                        -- Save an hlgroup with dark background and dimmed foreground
                        -- so that you can use it where your still want darker windows.
                        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                        -- NormalDark = {
                        --     fg = theme.ui.fg_dim,
                        --     bg = theme.ui.bg_m3,
                        -- },

                        -- Popular plugins that open floats will link to NormalFloat by default;
                        -- set their background accordingly if you wish to keep them dark and borderless
                        LazyNormal = {
                            bg = 'none',
                            fg = theme.ui.fg_dim,
                        },
                        MasonNormal = {
                            bg = 'none',
                            fg = theme.ui.fg_dim,
                        },
                        Pmenu = {
                            fg = theme.ui.shade0,
                            bg = theme.ui.bg_p1,
                            blend = vim.o.pumblend,
                        },
                        PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end,
                background = {
                    -- map the value of 'background' option to a theme
                    dark = 'dragon', -- try "dragon" !
                    light = 'lotus',
                },
            })
            vim.cmd.colorscheme('kanagawa')
        end,
    },
}
