local Util = require('user.util')

return {
    -- Status Column
    --
    {
        'luukvbaal/statuscol.nvim',
        config = function()
            local builtin = require('statuscol.builtin')
            require('statuscol').setup({
                relculright = false,
                segments = {
                    {
                        sign = {
                            name = { 'Diagnostic' },
                            maxwidth = 2,
                            colwidth = 2,
                            auto = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    {
                        sign = {
                            namespace = { '.*' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = true,
                        },
                    },
                    { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
                    {
                        sign = {
                            name = { '.*' },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true,
                            wrap = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
                },
            })
        end,
    },

    -- Better quickfix window
    --
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        opts = {
            preview = {
                winblend = 0,
            },
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other
    -- instances.
    -- {
    --     'RRethy/vim-illuminate',
    --     event = { 'BufReadPost', 'BufNewFile' },
    --     opts = {
    --         providers = {
    --             'lsp',
    --             'treesitter',
    --             'regex',
    --         },
    --         delay = 200,
    --         filetypes_denylist = {
    --             'oil',
    --             'fugitive',
    --             'qf',
    --             'TelescopePrompt',
    --             'Trouble',
    --             'DiffviewFiles',
    --             'DiffviewFileHistory',
    --         },
    --         large_file_cutoff = 2000,
    --         large_file_overrides = {
    --             providers = {
    --                 'lsp',
    --             },
    --         },
    --     },
    --     config = function(_, opts)
    --         require('illuminate').configure(opts)
    --
    --         local function map(key, dir, buffer)
    --             vim.keymap.set('n', key, function()
    --                 require('illuminate')['goto_' .. dir .. '_reference'](false)
    --             end, {
    --                 desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
    --                 buffer = buffer,
    --             })
    --         end
    --         local bufnr = vim.api.nvim_get_current_buf()
    --
    --         map(']]', 'next', bufnr)
    --         map('[[', 'prev', bufnr)
    --         --
    --         --     -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    --         --     vim.api.nvim_create_autocmd('FileType', {
    --         --         pattern = require('illuminate').
    --         --         callback = function()
    --         --             local buffer = vim.api.nvim_get_current_buf()
    --         --             map(']]', 'next', buffer)
    --         --             map('[[', 'prev', buffer)
    --         --         end,
    --         -- })
    --     end,
    --     -- keys = {
    --     --     { ']]', desc = 'Next Reference' },
    --     --     { '[[', desc = 'Prev Reference' },
    --     -- },
    -- },

    -- Quickfixtextfunc function and syntax rules for quickfix/location list buffers.
    {
        'yorickpeterse/nvim-pqf',
        event = 'VeryLazy',
        opts = {
            show_multiple_lines = true,
            max_filename_length = 40,
        },
    },

    -- Pretty bufferline.
    {
        'akinsho/bufferline.nvim',
        event = 'VeryLazy',
        dependencies = {
            'echasnovski/mini.bufremove',
            config = true,
        },
        opts = function()
            local highlights = function()
                local bg = '#2a2a37'
                return {
                    fill = {
                        bg = bg,
                    },
                    background = {
                        bg = bg,
                    },
                    buffer = {
                        bg = bg,
                    },
                    buffer_visible = {
                        bg = bg,
                    },
                    diagnostic = {
                        bg = bg,
                    },
                    diagnostic_visible = {
                        bg = bg,
                    },
                    hint = {
                        bg = bg,
                    },
                    hint_visible = {
                        bg = bg,
                    },
                    hint_diagnostic = {
                        bg = bg,
                    },
                    hint_diagnostic_visible = {
                        bg = bg,
                    },
                    warning = {
                        bg = bg,
                    },
                    warning_visible = {
                        bg = bg,
                    },
                    warning_diagnostic = {
                        bg = bg,
                    },
                    warning_diagnostic_visible = {
                        bg = bg,
                    },
                    error = {
                        bg = bg,
                    },
                    error_visible = {
                        bg = bg,
                    },
                    error_diagnostic = {
                        bg = bg,
                    },
                    error_diagnostic_visible = {
                        bg = bg,
                    },
                    info = {
                        bg = bg,
                    },
                    info_visible = {
                        bg = bg,
                    },
                    info_diagnostic = {
                        bg = bg,
                    },
                    info_diagnostic_visible = {
                        bg = bg,
                    },
                    modified = {
                        bg = bg,
                    },
                    modified_visible = {
                        bg = bg,
                    },
                    -- separator = {
                    --     fg = '#191919',
                    -- },
                    -- separator_visible = {
                    --     fg = '#191919',
                    -- },
                    -- separator_selected = {
                    --     fg = '#191919',
                    --     bg = '#98bb6c',
                    -- },
                    indicator_visible = {
                        fg = bg,
                        bg = bg,
                    },
                    indicator_selected = {
                        fg = '#98bb6c',
                        bg = '#98bb6c',
                    },
                }
            end

            return {
                highlights = highlights,
                options = {
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                    truncate_names = false,
                    separator_style = { '', '' },
                    indicator = { style = 'icon' },
                    close_command = function(bufnr)
                        require('mini.bufremove').delete(bufnr, false)
                    end,
                    diagnostics = 'nvim_lsp',
                    diagnostics_update_in_insert = false,
                    diagnostics_indicator = function(_, _, diag)
                        local icons = require('user.config.icons').diagnostics
                        local indicator = (
                            diag.error and icons.ERROR .. ' ' or ''
                        )
                            .. (diag.warning and icons.WARN or '')
                        return vim.trim(indicator)
                    end,
                    offsets = {
                        {
                            text = 'EXPLORER',
                            filetype = 'neo-tree',
                            highlight = 'PanelHeading',
                            text_align = 'left',
                            separator = true,
                        },
                        {
                            text = 'UNDOTREE',
                            filetype = 'undotree',
                            highlight = 'PanelHeading',
                            separator = true,
                        },
                        {
                            text = '󰆼 DATABASE VIEWER',
                            filetype = 'dbui',
                            highlight = 'PanelHeading',
                            separator = true,
                        },
                        {
                            text = ' DIFF VIEW',
                            filetype = 'DiffviewFiles',
                            highlight = 'PanelHeading',
                            separator = true,
                        },
                    },
                },
            }
        end,
        keys = {
            -- Buffer navigation.
            { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous buffer' },
            { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
            {
                '<leader>bc',
                '<cmd>BufferLinePickClose<cr>',
                desc = 'Select a buffer to close',
            },
            {
                '<leader>bch',
                '<cmd>BufferLineCloseLeft<cr>',
                desc = 'Close buffers to the left',
            },
            {
                '<leader>bo',
                '<cmd>BufferLinePick<cr>',
                desc = 'Select a buffer to open',
            },
            {
                '<leader>bcl',
                '<cmd>BufferLineCloseRight<cr>',
                desc = 'Close buffers to the right',
            },
        },
    },
}
