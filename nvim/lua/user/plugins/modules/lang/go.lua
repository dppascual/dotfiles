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
                    cmd = { 'gopls', '-rpc.trace' },
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
                    -- stylua: ignore
                    vim.api.nvim_create_autocmd("LspAttach", {
                        callback = function(ev)
                            local client = vim.lsp.get_client_by_id(ev.data.client_id)
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
                        end
                    })-- end workaround

                    -- Run gofmt/gofumpt, import packages automatically on save
                    -- stylua: ignore
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = vim.api.nvim_create_augroup( 'GoFormatting', { clear = true }
                        ),
                        pattern = '*.go',
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context =
                                { only = { 'source.organizeImports' } }
                            local result = vim.lsp.buf_request_sync(
                                0,
                                'textDocument/codeAction',
                                params,
                                2000
                            )
                            for _, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        vim.lsp.util.apply_workspace_edit(
                                            r.edit,
                                            'utf-16'
                                        )
                                    else
                                        vim.lsp.buf.execute_command(r.command)
                                    end
                                end
                            end

                            vim.lsp.buf.format()
                        end,
                    })
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
