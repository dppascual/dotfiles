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
            {
                'kosayoda/nvim-lightbulb',
                opts = {
                    sign = { enabled = true, text = '' },
                    autocmd = { enabled = true },
                },
            },
            {
                'weilbith/nvim-code-action-menu',
                cmd = 'CodeActionMenu',
                config = function()
                    vim.g.code_action_menu_window_border = CUSTOM_BORDER
                    vim.g.code_action_menu_show_details = false
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

                    -- stylua: ignore start
                    if client and client.supports_method('textDocument/inlayHint') then
                        local inlay_hints_group = vim.api.nvim_create_augroup('InlayHints', { clear = false })

                        -- Initial inlay hint display.
                        local mode = vim.api.nvim_get_mode().mode
                        vim.lsp.inlay_hint(ev.buf, mode == 'n' or mode == 'v')

                        vim.api.nvim_create_autocmd('InsertEnter', {
                            group = inlay_hints_group,
                            desc = "Enable inlay hints",
                            buffer = ev.buf,
                            callback = function()
                                vim.lsp.inlay_hint(ev.buf, false)
                            end,
                        })
                        vim.api.nvim_create_autocmd('InsertLeave', {
                            group = inlay_hints_group,
                            desc = "Disable inlay hints",
                            buffer = ev.buf,
                            callback = function()
                                vim.lsp.inlay_hint(ev.buf, true)
                            end,
                        })
                        -- vim.keymap.set({ 'n', 'v' }, '<leader>i', function()
                        --     vim.lsp.inlay_hint(ev.buf, nil)
                        -- end, {
                        --     noremap = true,
                        --     silent = true,
                        -- })
                    end
                    -- stylua: ignore end
                end,
            })

            -- Lspconfig
            --
            local servers = opts.servers ---@type table<string, table>
            local capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities(),
                {
                    workspace = {
                        -- PERF: didChangeWatchedFiles is too slow.
                        -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
                        didChangeWatchedFiles = { dynamicRegistration = false },
                    },
                },
                {
                    textDocument = {
                        -- Enable folding.
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true,
                        },
                    },
                }
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

            local md_namespace =
                vim.api.nvim_create_namespace('dppascual/lsp_float')

            ---LSP handler that adds extra inline highlights, keymaps, and window options.
            ---Code inspired from `noice`.
            ---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
            ---@return function
            local function enhanced_float_handler(handler)
                return function(err, result, ctx, config)
                    local buf, win = handler(
                        err,
                        result,
                        ctx,
                        vim.tbl_deep_extend('force', config or {}, {
                            border = CUSTOM_BORDER,
                            max_height = math.floor(vim.o.lines * 0.5),
                            max_width = math.floor(vim.o.columns * 0.4),
                        })
                    )

                    if not buf or not win then
                        return
                    end

                    -- Conceal everything.
                    vim.wo[win].concealcursor = 'n'

                    -- Extra highlights.
                    for l, line in
                        ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
                    do
                        for pattern, hl_group in pairs({
                            ['|%S-|'] = '@text.reference',
                            ['@%S+'] = '@parameter',
                            ['^%s*(Parameters:)'] = '@text.title',
                            ['^%s*(Return:)'] = '@text.title',
                            ['^%s*(See also:)'] = '@text.title',
                            ['{%S-}'] = '@parameter',
                        }) do
                            local from = 1 ---@type integer?
                            while from do
                                local to
                                from, to = line:find(pattern, from)
                                if from then
                                    vim.api.nvim_buf_set_extmark(
                                        buf,
                                        md_namespace,
                                        l - 1,
                                        from - 1,
                                        {
                                            end_col = to,
                                            hl_group = hl_group,
                                        }
                                    )
                                end
                                from = to and to + 1 or nil
                            end
                        end
                    end

                    -- Add keymaps for opening links.
                    if not vim.b[buf].markdown_keys then
                        vim.keymap.set('n', 'gx', function()
                            -- Vim help links.
                            local url = (
                                vim.fn.expand('<cWORD>') --[[@as string]]
                            ):match('|(%S-)|')
                            if url then
                                return vim.cmd.help(url)
                            end

                            -- Markdown links.
                            local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                            local from, to
                            from, to, url = vim.api
                                .nvim_get_current_line()
                                :find('%[.-%]%((%S-)%)')
                            if from and col >= from and col <= to then
                                vim.system({ 'open', url }, nil, function(res)
                                    if res.code ~= 0 then
                                        vim.notify(
                                            'Failed to open URL' .. url,
                                            vim.log.levels.ERROR
                                        )
                                    end
                                end)
                            end
                        end, {
                            buffer = buf,
                            silent = true,
                        })
                        vim.b[buf].markdown_keys = true
                    end
                end
            end

            -- Hover configuration
            --
            vim.lsp.handlers['textDocument/hover'] =
                enhanced_float_handler(vim.lsp.handlers.hover)

            -- Signature Help configuration
            --
            vim.lsp.handlers['textDocument/signatureHelp'] =
                enhanced_float_handler(vim.lsp.handlers.signature_help)

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
}
