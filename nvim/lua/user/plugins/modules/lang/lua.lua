return {
    -- Add lua to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'lua' })
            end
        end,
    },

    -- Add lua formatter to mason
    --
    {
        'stevearc/conform.nvim',
        dependencies = {
            'mason.nvim',
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { 'stylua' })
            end,
        },
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
            },
        },
    },

    -- Correctly setup lspconfig for proto
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                workspaceWord = true,
                                callSnippet = 'Replace',
                            },
                            misc = {
                                parameters = {
                                    '--log-level=trace',
                                },
                            },
                            diagnostics = {
                                -- enable = false,
                                groupSeverity = {
                                    strong = 'Warning',
                                    strict = 'Warning',
                                },
                                groupFileStatus = {
                                    ['ambiguity'] = 'Opened',
                                    ['await'] = 'Opened',
                                    ['codestyle'] = 'None',
                                    ['duplicate'] = 'Opened',
                                    ['global'] = 'Opened',
                                    ['luadoc'] = 'Opened',
                                    ['redefined'] = 'Opened',
                                    ['strict'] = 'Opened',
                                    ['strong'] = 'Opened',
                                    ['type-check'] = 'Opened',
                                    ['unbalanced'] = 'Opened',
                                    ['unused'] = 'Opened',
                                },
                                unusedLocalExclude = { '_*' },
                            },
                            format = {
                                enable = false,
                                defaultConfig = {
                                    indent_style = 'space',
                                    indent_size = '2',
                                    continuation_indent_size = '2',
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
