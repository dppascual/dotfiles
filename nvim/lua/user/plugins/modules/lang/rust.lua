return {

    -- Extend auto completion
    --
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                'Saecki/crates.nvim',
                event = { 'BufRead Cargo.toml' },
                opts = {
                    src = {
                        cmp = { enabled = true },
                    },
                    popup = {
                        border = CUSTOM_BORDER,
                    },
                },
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
                vim.list_extend(
                    opts.ensure_installed,
                    { 'ron', 'rust', 'toml' }
                )
            end
        end,
    },

    -- Formatting
    --
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                -- Deprecated to be installed by mason (intalled with rustup)
                rust = { 'rustfmt' },
            },
        },
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
                    -- keys = {
                    --     {
                    --         'K',
                    --         '<cmd>RustHoverActions<cr>',
                    --         desc = 'Hover Actions (Rust)',
                    --     },
                    --     {
                    --         '<leader>ca',
                    --         '<cmd>RustCodeAction<cr>',
                    --         desc = 'Code Action (Rust)',
                    --     },
                    --     {
                    --         '<leader>dr',
                    --         '<cmd>RustDebuggables<cr>',
                    --         desc = 'Run Debuggables (Rust)',
                    --     },
                    -- },
                    settings = {
                        ['rust-analyzer'] = {
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
                -- taplo = {
                --     keys = {
                --         {
                --             'K',
                --             function()
                --                 if
                --                     vim.fn.expand('%:t') == 'Cargo.toml'
                --                     and require('crates').popup_available()
                --                 then
                --                     require('crates').show_popup()
                --                 else
                --                     vim.lsp.buf.hover()
                --                 end
                --             end,
                --             desc = 'Show Crate Documentation',
                --         },
                --     },
                -- },
            },
            setup = {
                rust_analyzer = function(_, opts)
                    require('rust-tools').setup({
                        tools = {
                            on_initialized = function()
                                vim.cmd([[
                                  augroup RustLSP
                                  autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                                  autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                                  autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                                  augroup END
                                ]])
                            end,
                            inlay_hints = { auto = false },
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
