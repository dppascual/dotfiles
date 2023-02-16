return {
    -- lspconfig
    --
    {
        'neovim/nvim-lspconfig',
        event = 'BufReadPre',
        dependencies = {
            -- LSP
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'jose-elias-alvarez/null-ls.nvim',

            -- Snippet
            -- The dependency of LuaSnip is added because "hrsh7th/cmp-nvim-lsp"
            -- is a lazy-loaded plugin that is triggered when Luasnip is loaded.
            'L3MON4D3/LuaSnip',

            -- Hints
            'lvimuser/lsp-inlayhints.nvim',

            -- UI
            'j-hui/fidget.nvim',
            'ray-x/lsp_signature.nvim',
            { 'simrat39/symbols-outline.nvim', config = true },

            -- Tools
            'b0o/schemastore.nvim',
            'folke/neodev.nvim',
            'simrat39/rust-tools.nvim',
        },
        config = function()
            -- Setup neovim lua configuration
            --
            require('neodev').setup()

            -- Diagnostic
            --
            require('user.plugins.lsp.diagnostics')

            -- Lspconfig
            --
            local servers = R('user.plugins.lsp.servers')
            local capabilities = require('cmp_nvim_lsp').default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )
            local on_attach = R('user.plugins.lsp.keymaps').on_attach

            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            -- LSP clients started up with lspconfig
            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    -- rust-analyzer is installed by using cargo
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        flags = {
                            debounce_text_changes = 150,
                        },
                    })
                end,
            })

            -- rust-analyzer
            require('rust-tools').setup({
                tools = {
                    autoSetHints = true,
                    runnables = { use_telescope = true },
                    inlay_hints = {
                        auto = true,
                        highlight = 'Whitespace',
                    },
                    hover_actions = {
                        border = CUSTOM_BORDER,
                        auto_focus = false,
                    },
                    executor = {
                        execute_command = function(command, args)
                            vim.cmd(
                                'T '
                                    .. require('rust-tools.utils.utils').make_command_from_args(
                                        command,
                                        args
                                    )
                            )
                        end,
                    },
                },
                server = {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    cmd = {
                        'rustup',
                        'run',
                        'stable',
                        'rust-analyzer',
                    },
                    flags = {
                        debounce_text_changes = 150,
                    },
                    settings = {
                        ['rust-analyzer'] = {
                            -- See: https://github.com/simrat39/rust-tools.nvim/issues/300
                            inlayHints = { locationLinks = false },
                            cargo = { allFeatures = true },
                            checkOnSave = {
                                allFeatures = true,
                                command = 'clippy',
                                extraArgs = { '--no-deps' },
                            },
                            completion = {
                                autoimport = {
                                    enable = true,
                                },
                            },
                        },
                    },
                },
            })

            -- Hover configuration
            --
            vim.lsp.handlers['textDocument/hover'] =
                vim.lsp.with(vim.lsp.handlers.hover, {
                    focusable = true,
                    style = 'minimal',
                    border = 'rounded',
                })

            -- Signature Help configuration
            --
            vim.lsp.handlers['textDocument/signature_help'] =
                vim.lsp.with(vim.lsp.handlers.signature_help, {
                    focusable = true,
                    style = 'minimal',
                    border = 'rounded',
                })

            -- Turn on lsp status information
            --
            require('fidget').setup()
        end,
    },

    -- cmdline tools and lsp servers
    --
    {
        'williamboman/mason.nvim',
        opts = {
            install_root_dir = vim.fn.stdpath('data') .. 'mason',
            PATH = 'prepend',
            ui = {
                border = 'rounded',
                icons = {
                    package_pending = ' ',
                    package_installed = ' ',
                    package_uninstalled = ' ',
                },
                keymaps = {
                    toggle_server_expand = '<CR>',
                    install_server = 'i',
                    update_server = 'u',
                    check_server_version = 'c',
                    update_all_servers = 'U',
                    check_outdated_servers = 'C',
                    uninstall_server = 'X',
                    cancel_installation = '<C-c>',
                },
            },
            ensure_installed = {
                'stylua',
                'shfmt',
            },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(plugin, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end,
    },

    -- null-ls
    --
    {
        'jose-elias-alvarez/null-ls.nvim',
        config = function()
            local formatting = require('null-ls').builtins.formatting

            require('null-ls').setup({
                debug = false,
                sources = {
                    formatting.stylua,
                    formatting.shfmt,
                },
            })
        end,
    },
}
