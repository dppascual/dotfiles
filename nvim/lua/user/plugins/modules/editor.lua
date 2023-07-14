return {
    -- File explorer
    --
    {
        'echasnovski/mini.files',
        opts = {
            windows = {
                preview = false,
                width_focus = 30,
                width_preview = 30,
            },
            options = {
                use_as_default_explorer = true,
            },
        },
        keys = {
            {
                '<leader>fm',
                function()
                    require('mini.files').open(
                        vim.api.nvim_buf_get_name(0),
                        true
                    )
                end,
                desc = 'Open mini.files (directory of current file)',
            },
            {
                '<leader>fM',
                function()
                    require('mini.files').open(vim.loop.cwd(), true)
                end,
                desc = 'Open mini.files (cwd)',
            },
        },
        config = function(_, opts)
            require('mini.files').setup(opts)

            local show_dotfiles = true
            local filter_show = function(fs_entry)
                return true
            end
            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, '.')
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                require('mini.files').refresh({
                    content = { filter = new_filter },
                })
            end

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local buf_id = args.data.buf_id
                    -- Tweak left-hand side of mapping to your liking
                    vim.keymap.set(
                        'n',
                        'g.',
                        toggle_dotfiles,
                        { buffer = buf_id }
                    )
                end,
            })

            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesWindowOpen',
                callback = function(args)
                    local win_id = args.data.win_id

                    -- Customize window-local settings
                    vim.wo[win_id].winblend = 0
                    vim.api.nvim_win_set_config(
                        win_id,
                        { border = CUSTOM_BORDER }
                    )
                end,
            })
        end,
    },

    -- Fuzzy Finder
    --
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local actions = require('telescope.actions')
            local action_layout = require('telescope.actions.layout')
            require('telescope').setup({
                defaults = {
                    initial_mode = 'insert',
                    select_strategy = 'reset',
                    sorting_strategy = 'ascending',
                    layout_strategy = 'horizontal',
                    layout_config = {
                        -- width = 1,
                        height = 0.33,
                        prompt_position = 'top',
                        preview_cutoff = 60,
                    },
                    mappings = {
                        n = {
                            ['<c-p>'] = action_layout.toggle_preview,
                        },
                        i = {
                            ['<c-p>'] = action_layout.toggle_preview,
                            ['<c-q>'] = actions.smart_send_to_qflist
                                + actions.open_qflist,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
                    },
                },
            })

            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require('telescope').load_extension('fzf')

            local function keymapFn(lhs, rhs, opts)
                opts = opts or {}
                vim.keymap.set(
                    opts.mode or 'n',
                    lhs,
                    type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
                    {
                        noremap = true,
                        silent = true,
                        expr = opts.expr,
                        desc = opts.desc,
                    }
                )
            end

            local builtin = require('telescope.builtin')
            -- Keymaps
            --
            keymapFn('<leader>?', builtin.builtin, { desc = '[?] Built-in' })
            keymapFn(
                '<leader>:',
                builtin.commands,
                { desc = '[:] User Commands' }
            )

            -- Buffers
            --
            keymapFn('<leader>b', builtin.buffers, { desc = '[B]uffers' })
            keymapFn(
                '<leader>sb',
                builtin.current_buffer_fuzzy_find,
                { desc = 'Fuzzily [S]earch in current [B]uffer' }
            )

            -- Files
            --
            keymapFn(
                '<leader>ff',
                builtin.find_files,
                { desc = '[F]ind [F]iles' }
            )
            keymapFn(
                '<leader>sf',
                builtin.live_grep,
                { desc = '[S]earch in [F]iles' }
            )

            -- Search
            --
            keymapFn(
                '<leader>*',
                builtin.grep_string,
                { desc = '[S]earch current [W]ord' }
            )

            -- Git
            --
            keymapFn(
                '<leader>gf',
                builtin.git_files,
                { desc = '[G]it [F]iles' }
            )
            keymapFn(
                '<leader>gb',
                builtin.git_branches,
                { desc = '[G]it [B]ranches' }
            )

            -- Diagnostic
            --
            keymapFn(
                '<leader>d',
                "lua require('telescope.builtin').diagnostics( { bufnr = 0 } )",
                { desc = 'Document [d]iagnostics' }
            )
            keymapFn(
                '<leader>D',
                builtin.diagnostics,
                { desc = 'Workspace [D]iagnostics' }
            )
        end,
    },

    -- Harpoon
    --
    {
        'theprimeagen/harpoon',
        config = function()
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')

            vim.keymap.set('n', '<leader>a', mark.add_file)
            vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

            vim.keymap.set('n', '<leader>1', function()
                ui.nav_file(1)
            end)
            vim.keymap.set('n', '<leader>2', function()
                ui.nav_file(2)
            end)
            vim.keymap.set('n', '<leader>3', function()
                ui.nav_file(3)
            end)
            vim.keymap.set('n', '<leader>4', function()
                ui.nav_file(4)
            end)
        end,
    },

    -- Status Column
    --
    {
        'luukvbaal/statuscol.nvim',
        config = function()
            local builtin = require('statuscol.builtin')
            require('statuscol').setup({
                relculright = false,
                segments = {
                    {
                        sign = {
                            name = { 'Diagnostic' },
                            maxwidth = 2,
                            auto = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
                    {
                        sign = {
                            name = { '.*' },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true,
                            wrap = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    {
                        text = { builtin.foldfunc },
                        click = 'v:lua.ScFa',
                    },
                },
            })
        end,
    },

    -- TODO Comments
    --
    {
        'folke/todo-comments.nvim',
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            signs = false,
        },
        keys = {
            {
                ']t',
                function()
                    require('todo-comments').jump_next()
                end,
                desc = 'Next todo comment',
            },
            {
                '[t',
                function()
                    require('todo-comments').jump_prev()
                end,
                desc = 'Previous todo comment',
            },
            { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
            {
                '<leader>sT',
                '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',
                desc = 'Todo/Fix/Fixme',
            },
        },
    },

    -- Alternate between files, such as foo.go and foo_test.go
    --
    {
        'rgroli/other.nvim',
        config = function()
            require('other-nvim').setup({
                mappings = {
                    'golang', --builtin mapping
                },
            })
        end,
    },

    -- Better quickfix window
    --
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        opts = {
            preview = {
                winblend = 0,
            },
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    -- Git plugins
    --
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '▎' },
                    change = { text = '▎' },
                    delete = { text = '▎' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked = { text = '▎' },
                },
                signcolumn = true,
                numhl = true,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                status_formatter = nil, -- Use default
                update_debounce = 200,
                max_file_length = 40000,
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'rounded',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1,
                },
                yadm = { enable = false },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']g', function()
                        if vim.wo.diff then
                            return ']c'
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    map('n', '[g', function()
                        if vim.wo.diff then
                            return '[c'
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- Actions
                    map(
                        'n',
                        ']h',
                        '<CMD>lua require"gitsigns.actions".next_hunk()<CR>'
                    )
                    map(
                        'n',
                        '[h',
                        '<CMD>lua require"gitsigns.actions".prev_hunk()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gs',
                        '<CMD>lua require"gitsigns".stage_hunk()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gu',
                        '<CMD>lua require"gitsigns".undo_stage_hunk()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gr',
                        '<CMD>lua require"gitsigns".reset_hunk()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gR',
                        '<CMD>lua require"gitsigns".reset_buffer()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gp',
                        '<CMD>lua require"gitsigns".preview_hunk_inline()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gb',
                        '<CMD>lua require"gitsigns".toggle_current_line_blame()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gS',
                        '<CMD>lua require"gitsigns".stage_buffer()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gD',
                        '<CMD>lua require"gitsigns".diffthis()<CR>'
                    )
                    map(
                        'n',
                        '<leader>gd',
                        '<CMD>lua require"gitsigns".toggle_deleted()<CR>'
                    )

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end,
            })
        end,
    },

    {
        'tpope/vim-fugitive',
    },
    {
        'sindrets/diffview.nvim',
        cmd = {
            'DiffviewOpen',
            'DiffviewFileHistory',
        },
    },

    -- testing framework
    --
    {
        'vim-test/vim-test',
        config = function()
            vim.g['test#strategy'] = 'neovim'
            vim.g['test#neovim#start_normal'] = '1'
        end,
    },
}
