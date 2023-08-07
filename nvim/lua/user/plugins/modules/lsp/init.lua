return {
    -- lspconfig
    --
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            -- LSP
            'mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'jose-elias-alvarez/null-ls.nvim',
            {
                'folke/neodev.nvim',
                opts = {},
            },
            {
                'hrsh7th/cmp-nvim-lsp',
                cond = function()
                    return require('lazy.core.config').spec.plugins['nvim-cmp']
                        ~= nil
                end,
            },

            -- UI
            {
                'dnlhc/glance.nvim',
                opts = {
                    preview_win_opts = {
                        cursorline = false,
                        relativenumber = false,
                        colorcolumn = '',
                    },
                    border = {
                        enable = true,
                    },
                    hooks = {
                        before_open = function(results, open, jump, method)
                            if #results == 1 then
                                jump(results[1]) -- argument is optional
                            else
                                open(results) -- argument is optional
                            end
                        end,
                    },
                },
            },
            {
                'j-hui/fidget.nvim',
                tag = 'legacy',
                opts = {
                    window = {
                        blend = 0,
                    },
                    text = {
                        spinner = 'dots',
                    },
                },
            },
            { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', opts = {} },
            -- {
            --     'kosayoda/nvim-lightbulb',
            --     opts = {
            --         sign = { enabled = false },
            --         virtual_text = { enabled = true, text = '' },
            --         autocmd = { enabled = true },
            --     },
            -- },
            {
                'weilbith/nvim-code-action-menu',
                cmd = 'CodeActionMenu',
                config = function()
                    vim.g.code_action_menu_window_border = CUSTOM_BORDER
                end,
            },

            -- Tools
        },
        opts = {
            ---@type table -- Filled up by each language module
            servers = {},
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server_name:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        config = function(_, opts)
            -- Diagnostic
            --
            require('user.plugins.modules.lsp.diagnostics')

            -- Keymaps
            --
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    require('user.plugins.modules.lsp.keymaps').on_attach(
                        client,
                        ev.buf
                    )
                end,
            })

            -- Inlay hints
            --
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    if
                        client
                        and client.supports_method('textDocument/inlayHint')
                    then
                        vim.keymap.set({ 'n', 'v' }, '<leader>h', function()
                            vim.lsp.inlay_hint(ev.buf, nil)
                        end, {
                            noremap = true,
                            silent = true,
                        })
                    end
                end,
            })

            -- Lspconfig
            --
            local servers = opts.servers ---@type table<string, table>
            local capabilities = require('cmp_nvim_lsp').default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            local function setup(server_name)
                local server_opts = vim.tbl_deep_extend(
                    'force',
                    { capabilities = vim.deepcopy(capabilities) },
                    { flags = { debounce_text_changes = 150 } },
                    servers[server_name] or {}
                )

                if opts.setup[server_name] then
                    if opts.setup[server_name](server_name, server_opts) then
                        return
                    end
                elseif opts.setup['*'] then
                    if opts.setup['*'](server_name, server_opts) then
                        return
                    end
                end

                require('lspconfig')[server_name].setup(server_opts)
            end

            -- Check if lsp should be installed by mason
            local ensure_installed = {} ---@type string[]
            for server_name, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false
                    if server_opts.mason == false then
                        setup(server_name)
                    else
                        ensure_installed[#ensure_installed + 1] = server_name
                    end
                end
            end

            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed,
                handlers = { setup },
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
            vim.lsp.handlers['textDocument/signatureHelp'] =
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
        cmd = { 'Mason' },
        opts = {
            install_root_dir = vim.fn.stdpath('data') .. '/mason',
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
            ensure_installed = { 'prettier' },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },

    -- null-ls
    --
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'mason.nvim' },
        opts = function()
            local nls = require('null-ls')
            return {
                debug = false,
                sources = { nls.builtins.formatting.prettier },
            }
        end,
    },
}
