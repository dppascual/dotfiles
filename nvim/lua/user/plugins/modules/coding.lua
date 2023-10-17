return {

    -- Snippets
    --
    {
        'L3MON4D3/LuaSnip',
        lazy = true,
        build = 'make install_jsregexp',
        opts = {
            history = true,
            delete_check_events = 'TextChanged',
            updateevents = 'InsertLeave,TextChanged,TextChangedI',
            enable_autosnippets = false,
        },
        dependencies = {
            'rafamadriz/friendly-snippets',
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
    },

    -- Auto-completion
    --
    {
        'hrsh7th/nvim-cmp',
        commit = '6c84bc75c64f778e9f1dcb798ed41c7fcb93b639',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            { 'hrsh7th/cmp-cmdline', enabled = true },
            'saadparwaiz1/cmp_luasnip',
        },
        opts = function()
            local kind_icons = {
                Namespace = ' ',
                Text = ' ',
                Method = ' ',
                Function = ' ',
                Constructor = ' ',
                Field = ' ',
                Variable = ' ',
                Class = ' ',
                Interface = ' ',
                Module = ' ',
                Property = ' ',
                Unit = ' ',
                Value = ' ',
                Enum = ' ',
                Keyword = ' ',
                Snippet = ' ',
                Color = ' ',
                File = ' ',
                Reference = ' ',
                Folder = ' ',
                EnumMember = ' ',
                Constant = ' ',
                Struct = ' ',
                Event = ' ',
                Operator = ' ',
                TypeParameter = ' ',
                Table = '',
                Object = ' ',
                Tag = '',
                Array = '[]',
                Boolean = ' ',
                Number = ' ',
                Null = 'ﳠ',
                String = ' ',
                Calendar = '',
                Watch = ' ',
                Package = '',
                Copilot = ' ',
                Codeium = ' ',
            }

            local cmp = require('cmp')
            local defaults = require('cmp.config.default')()
            local luasnip = require('luasnip')

            -- select_item detects the order in which elements are shown
            -- and keeps the same motion.
            local select_item = function(direction, behavior)
                return function(fallback)
                    if cmp.visible() then
                        if
                            cmp.core.view.custom_entries_view:is_direction_top_down()
                        then
                            ({
                                next = cmp.select_next_item,
                                prev = cmp.select_prev_item,
                            })[direction]({
                                behavior = behavior,
                            })
                        else
                            ({
                                next = cmp.select_prev_item,
                                prev = cmp.select_next_item,
                            })[direction]({
                                behavior = behavior,
                            })
                        end
                    else
                        fallback()
                    end
                end
            end

            return {
                sources = {
                    {
                        name = 'nvim_lsp',
                        max_item_count = 20,
                        keyword_length = 0,
                    },
                    { name = 'luasnip' },
                    {
                        name = 'buffer',
                        keyword_length = 5,
                    },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                },

                completion = {
                    completeopt = 'menu,menuone,noinsert',
                    -- keyword_length = 2,
                },

                matching = {
                    disallow_partial_fuzzy_matching = false,
                },

                preselect = cmp.PreselectMode.None,

                view = {
                    entries = {
                        name = 'custom',
                        selection_order = 'near_cursor',
                    },
                },

                window = {
                    completion = {
                        border = CUSTOM_BORDER,
                        winhighlight = 'NormalFloat:Normal,CursorLine:Visual',
                    },
                    documentation = {
                        border = CUSTOM_BORDER,
                        winhighlight = 'NormalFloat:Normal,CursorLine:Visual',
                    },
                },

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                formatting = {
                    format = function(entry, item)
                        item.kind = string.format(
                            '%s %s',
                            kind_icons[item.kind],
                            item.kind
                        )
                        item.menu = ({
                            buffer = '[Buffer]',
                            path = '[Path]',
                            nvim_lsp = '[LSP]',
                            luasnip = '[Snip]',
                            nvim_lua = '[Lua]',
                        })[entry.source.name]

                        return item
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ['<down>'] = select_item('next', cmp.SelectBehavior.Select),
                    ['<up>'] = select_item('prev', cmp.SelectBehavior.Select),
                    ['<C-j>'] = select_item('next', cmp.SelectBehavior.Select),
                    ['<C-k>'] = select_item('prev', cmp.SelectBehavior.Select),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        -- behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end),
                }),

                sorting = defaults.sorting,
            }
        end,
        config = function(_, opts)
            local cmp = require('cmp')
            cmp.setup(opts)

            if require('user.util').has('cmp-cmdline') ~= nil then
                -- Use buffer source for `/`
                cmp.setup.cmdline('/', {
                    completion = {
                        completeopt = 'menu,menuone,noselect',
                    },

                    mapping = cmp.mapping.preset.cmdline({
                        ['<down>'] = cmp.select_next_item,
                        ['<up>'] = cmp.select_prev_item,
                        ['<C-j>'] = cmp.select_next_item,
                        ['<C-k>'] = cmp.select_prev_item,
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-e>'] = { c = cmp.mapping.close() },
                        ['<Tab>'] = {
                            c = function()
                                if cmp.visible() then
                                    cmp.select_next_item()
                                else
                                    cmp.complete()
                                end
                            end,
                        },
                        ['<S-Tab>'] = {
                            c = function()
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                else
                                    cmp.complete()
                                end
                            end,
                        },
                    }),

                    sources = {
                        { name = 'buffer' },
                    },
                })

                -- Use cmdline & path source for ':'
                cmp.setup.cmdline(':', {
                    completion = {
                        completeopt = 'menu,menuone,noselect',
                    },

                    mapping = cmp.mapping.preset.cmdline({
                        ['<down>'] = cmp.select_next_item,
                        ['<up>'] = cmp.select_prev_item,
                        ['<C-j>'] = cmp.select_next_item,
                        ['<C-k>'] = cmp.select_prev_item,
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-e>'] = { c = cmp.mapping.close() },
                        ['<Tab>'] = {
                            c = function()
                                if cmp.visible() then
                                    cmp.select_next_item()
                                else
                                    cmp.complete()
                                end
                            end,
                        },
                        ['<S-Tab>'] = {
                            c = function()
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                else
                                    cmp.complete()
                                end
                            end,
                        },
                    }),

                    sources = cmp.config.sources({
                        { name = 'path' },
                    }, {
                        { name = 'cmdline', max_item_count = 20 },
                    }),
                })
            end

            vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
        end,
    },

    -- Formatting
    --
    {
        'stevearc/conform.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'mason.nvim' },
        keys = {
            {
                '<leader>cF',
                function()
                    require('conform').format({ formatters = { 'injected' } })
                end,
                mode = { 'n', 'v' },
                desc = 'Format Injected Langs',
            },
        },
        init = function()
            -- formatexpr is automatically (when LSP attached to a buffer) assigned to
            -- vim.lsp.formatexpr which, in turn, makes use of vim.lsb.buf.format.
            -- It overwrites formatexpr option to use conform.
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = {
            ---@type table<string, conform.FormatterUnit[]>
            formatters_by_ft = {
                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ['_'] = { 'trim_whitespace' },
            },
            ---@type table<string,table>
            formatters = {
                injected = { options = { ignore_errors = true } },
            },
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 1000,
                lsp_fallback = true,
            },
        },
        config = function(_, opts)
            opts.formatters = opts.formatters or {}
            for name, formatter in pairs(opts.formatters) do
                if type(formatter) == 'table' then
                    local ok, defaults =
                        pcall(require, 'conform.formatters.' .. name)
                    if ok and type(defaults) == 'table' then
                        opts.formatters[name] = vim.tbl_deep_extend(
                            'force',
                            {},
                            defaults,
                            formatter
                        )
                    end
                end
            end
            require('conform').setup(opts)
        end,
    },

    -- Linting
    --
    {
        'mfussenegger/nvim-lint',
        event = 'VeryLazy',
        opts = {
            -- Event to trigger linters
            events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
            linters_by_ft = {},
            ---@type table<string,table>
            linters = {
                -- -- Example of using selene only when a selene.toml file is present
                -- selene = {
                --   -- `condition` is another extension that allows you to
                --   -- dynamically enable/disable linters based on the context.
                --   condition = function(ctx)
                --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
                --   end,
                -- },
            },
        },
        config = function(_, opts)
            local M = {}

            local lint = require('lint')
            for name, linter in pairs(opts.linters) do
                if
                    type(linter) == 'table'
                    and type(lint.linters) == 'table'
                then
                    lint.linters[name] =
                        vim.tbl_deep_extend('force', lint.linters[name], linter)
                end
            end
            lint.linters_by_ft = opts.linters_by_ft

            function M.debounce(ms, fn)
                local timer = vim.loop.new_timer()
                return function(...)
                    local argv = { ... }
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(fn)(unpack(argv))
                    end)
                end
            end

            function M.lint()
                local names = lint.linters_by_ft[vim.bo.filetype] or {}
                local ctx = { filename = vim.api.nvim_buf_get_name(0) }
                ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
                names = vim.tbl_filter(function(name)
                    local linter = lint.linters[name]
                    return linter
                        and not (
                            type(linter) == 'table'
                            and linter.condition
                            and not linter.condition(ctx)
                        )
                end, names)

                if #names > 0 then
                    lint.try_lint(names)
                end
            end

            vim.api.nvim_create_autocmd(opts.events, {
                group = vim.api.nvim_create_augroup(
                    'nvim-lint',
                    { clear = true }
                ),
                callback = M.debounce(100, M.lint),
            })
        end,
    },

    -- Autopairs
    --
    {
        'echasnovski/mini.pairs',
        event = 'VeryLazy',
        opts = {},
    },

    -- Surround with TreeSitter
    --
    {
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {},
    },

    -- Comment with TreeSitter
    --
    { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
    {
        'echasnovski/mini.comment',
        event = 'VeryLazy',
        opts = {
            options = {
                custom_commentstring = function()
                    return require('ts_context_commentstring.internal').calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },

    -- Splitting/Joining blocks of code
    --
    {
        'Wansmer/treesj',
        keys = {
            { 'gS', '<cmd>TSJToggle<cr>', desc = 'Join Toggle' },
        },
        opts = {
            use_default_keymaps = false,
            max_join_length = 150,
        },
    },
}
