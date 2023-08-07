local Util = require('user.util')

return {
    -- File explorer
    --
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            win_options = {
                concealcursor = 'nvc',
            },
            keymaps = {
                ['l'] = 'actions.select',
                ['h'] = 'actions.parent',
                ['q'] = 'actions.close',
            },
        },
        keys = {
            {
                '-',
                function()
                    require('oil').open()
                end,
                { desc = 'Open parent directory' },
            },
            {
                '_',
                function()
                    require('oil').open(vim.fn.getcwd())
                end,
                { desc = 'Open current working directory' },
            },
        },
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
            'debugloop/telescope-undo.nvim',
            'theprimeagen/harpoon',
        },
        keys = {
            -- general
            {
                '<leader>?',
                '<cmd>Telescope builtin<cr>',
                desc = '[?] Built-in',
            },
            {
                '<leader>:',
                '<cmd>Telescope commands<cr>',
                desc = '[:] Commands',
            },

            -- buffers
            { '<leader>b', '<cmd>Telescope buffers<cr>', desc = '[B]uffers' },
            {
                '<leader>sb',
                '<cmd>Telescope current_buffer_fuzzy_find<cr>',
                desc = 'Fuzzily [S]earch in current [B]uffer',
            },

            -- files
            {
                '<leader>ff',
                Util.telescope('files'),
                desc = '[F]ind [F]iles (root dir)',
            },
            {
                '<leader>fF',
                Util.telescope('files', { cwd = vim.fn.expand('%:p:h') }),
                desc = '[F]ind [F]iles (cwd)',
            },
            {
                '<leader>fr',
                '<cmd>Telescope oldfiles<cr>',
                desc = '[F]iles [R]ecent',
            },
            {
                '<leader>sf',
                Util.telescope('live_grep'),
                desc = '[S]earch in [F]iles (root dir)',
            },
            {
                '<leader>sF',
                Util.telescope('live_grep', { cwd = vim.fn.expand('%:p:h') }),
                desc = '[S]earch in [F]iles (cwd)',
            },

            -- git
            {
                '<leader>gc',
                '<cmd>Telescope git_commits<CR>',
                desc = '[G]it [C]ommits',
            },
            {
                '<leader>gb',
                '<cmd>Telescope git_branches<CR>',
                desc = '[G]it [B]ranches',
            },

            -- workflow
            {
                '<leader>m',
                '<cmd>Telescope harpoon marks<cr>',
                desc = 'Jump to Mark',
            },

            -- search
            {
                '<leader>*',
                Util.telescope('grep_string', { word_match = '-w' }),
                desc = 'Search current Word (root dir)',
            },
            {
                '<leader>*',
                Util.telescope('grep_string'),
                mode = 'v',
                desc = 'Search current Selection (root dir)',
            },

            -- diagnostics
            {
                '<leader>xd',
                '<cmd>Telescope diagnostics bufnr=0<cr>',
                desc = '[D]ocument [D]iagnostics',
            },
            {
                '<leader>xw',
                '<cmd>Telescope diagnostics<cr>',
                desc = '[W]orkspace [D]iagnostics',
            },

            -- undo
            { '<leader>u', '<cmd>Telescope undo<cr>', desc = '[Undo] tree' },
        },
        config = function(_, opts)
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
                            ['<c-p>'] = require('telescope.actions.layout').toggle_preview,
                        },
                        i = {
                            ['<c-p>'] = require('telescope.actions.layout').toggle_preview,
                            ['<c-q>'] = require('telescope.actions').smart_send_to_qflist
                                + require('telescope.actions').open_qflist,
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
            require('telescope').load_extension('undo')
            require('telescope').load_extension('harpoon')
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
            vim.keymap.set('n', '<leader>5', function()
                ui.nav_file(5)
            end)
            vim.keymap.set('n', '<leader>6', function()
                ui.nav_file(6)
            end)
            vim.keymap.set('n', '<leader>7', function()
                ui.nav_file(7)
            end)
            vim.keymap.set('n', '<leader>8', function()
                ui.nav_file(8)
            end)
            vim.keymap.set('n', '<leader>9', function()
                ui.nav_file(9)
            end)
            vim.keymap.set('n', '<leader>0', function()
                ui.nav_file(0)
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
                    { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
                },
            })
        end,
    },

    -- Indent Highlight
    --
    {
        'shellRaining/hlchunk.nvim',
        event = { 'UIEnter' },
        opts = {
            indent = { enable = false },
            line_num = { enable = false },
            blank = { enable = false },
        },
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
        -- config = function()
        --     local group = vim.api.nvim_create_augroup("Diffview", { clear = true })
        --     vim.api.nvim_create_autocmd('DiffviewViewOpened', {
        --         group = group,
        --         callback = function(ev)
        --            require('hlchunk.mods.chunk'):disable()
        --         end,
        --     })
        -- end
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
