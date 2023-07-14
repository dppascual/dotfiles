return {

    -- Extend auto completion
    --
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                'Saecki/crates.nvim',
                event = { 'BufRead Cargo.toml' },
                config = true,
            },
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local cmp = require('cmp')
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
                { name = 'crates' },
            }))
        end,
    },

    -- Add rust & related to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'ron', 'rust' })
            end
        end,
    },

    -- Correctly setup lspconfig for rust
    --
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'simrat39/rust-tools.nvim',
        },
        opts = {
            servers = {
                rust_analyzer = {
                    mason = false,
                    keys = {
                        {
                            'K',
                            '<cmd>RustHoverActions<cr>',
                            desc = 'Hover Actions (Rust)',
                        },
                        {
                            '<leader>cR',
                            '<cmd>RustCodeAction<cr>',
                            desc = 'Code Action (Rust)',
                        },
                        {
                            '<leader>dr',
                            '<cmd>RustDebuggables<cr>',
                            desc = 'Run Debuggables (Rust)',
                        },
                    },
                    cmd = {
                        'rustup',
                        'run',
                        'stable',
                        'rust-analyzer',
                    },
                    settings = {
                        ['rust-analyzer'] = {
                            -- See: https://github.com/simrat39/rust-tools.nvim/issues/300
                            inlayHints = { locationLinks = false },
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            -- Add clippy lints for Rust.
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
                            procMacro = {
                                enable = true,
                                ignored = {
                                    ['async-trait'] = { 'async_trait' },
                                    ['napi-derive'] = { 'napi' },
                                    ['async-recursion'] = { 'async_recursion' },
                                },
                            },
                        },
                    },
                },
            },
            setup = {
                rust_analyzer = function(_, opts)
                    require('rust-tools').setup({
                        tools = {
                            autoSetHints = true,
                            runnables = { use_telescope = true },
                            inlay_hints = {
                                auto = false,
                                highlight = 'Whitespace',
                            },
                            hover_actions = {
                                border = CUSTOM_BORDER,
                                auto_focus = false,
                            },
                            executor = require('rust-tools.executors').termopen,
                        },
                        server = opts,
                    })
                    return true
                end,
            },
        },
    },
}
