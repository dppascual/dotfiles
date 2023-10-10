return {
    -- Add golang to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(
                    opts.ensure_installed,
                    { 'go', 'gomod', 'gowork', 'gosum' }
                )
            end
        end,
    },

    -- Correctly setup lspconfig for yaml
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            usePlaceholders = true,
                            gofumpt = true,
                            analyses = {
                                fieldalignment = true,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                                deprecated = true,
                            },
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            experimentalPostfixCompletions = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = {
                                '-.git',
                                '-.vscode',
                                '-.idea',
                                '-.vscode-test',
                                '-node_modules',
                            },
                            semanticTokens = true,
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                        },
                    },
                },
            },
            setup = {
                gopls = function(_, opts)
                    -- workaround for gopls not supporting semanticTokensProvider
                    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                    -- stylua: ignore
                    vim.api.nvim_create_autocmd("LspAttach", {
                        callback = function(ev)
                            local client = vim.lsp.get_client_by_id(ev.data.client_id)
                            if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
                                    local semantic = client.config.capabilities.textDocument.semanticTokens
                                    client.server_capabilities.semanticTokensProvider = {
                                        full = true,
                                        legend = {
                                            tokenTypes = semantic.tokenTypes,
                                            tokenModifiers = semantic.tokenModifiers,
                                        },
                                        range = true,
                                    }
                            end
                        end
                    })-- end workaround
                end,
            },
        },
    },

    -- Formatting
    --
    {
        'stevearc/conform.nvim',
        dependencies = {
            'mason.nvim',
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { 'goimports' })
            end,
        },
        opts = {
            formatters_by_ft = {
                go = { 'goimports' },
            },
        },
    },

    -- Better Go development
    --
    {
        'olexsmir/gopher.nvim',
        ft = {
            'go',
            'gomod',
            'gowork',
            'gosum',
        },
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
    },
}
