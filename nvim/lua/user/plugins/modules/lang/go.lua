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

    -- Add golang tools to mason
    {
        'jose-elias-alvarez/null-ls.nvim',
        opts = function(_, opts)
            local nls = require('null-ls')
            opts.sources = opts.sources or {}
            vim.list_extend(opts.sources, {
                nls.builtins.formatting.goimports_reviser,
            })
        end,
        dependencies = {
            'mason.nvim',
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { 'goimports-reviser' })
            end,
        },
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
                            directoryFilters = { '-.git', '-node_modules' },
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
                    require('user.util').on_attach(function(client, _)
                        if client.name == 'gopls' then
                            if
                                not client.server_capabilities.semanticTokensProvider
                            then
                                local semantic =
                                    client.config.capabilities.textDocument.semanticTokens
                                client.server_capabilities.semanticTokensProvider =
                                    {
                                        full = true,
                                        legend = {
                                            tokenTypes = semantic.tokenTypes,
                                            tokenModifiers = semantic.tokenModifiers,
                                        },
                                        range = true,
                                    }
                            end
                        end
                    end)
                    -- end workaround
                end,
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
