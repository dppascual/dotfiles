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

    -- Fuzzy Finder with fzf
    --
    {
        'ibhagwan/fzf-lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        -- stylua: ignore start
        keys = {
            -- general
            { '<leader>?', '<cmd>FzfLua builtin<cr>', desc = '[?] Built-in' },
            { '<leader>:', '<cmd>FzfLua commands<cr>', desc = '[:] Commands' },

            -- buffers
            { '<leader>b', '<cmd>FzfLua buffers<cr>', desc = '[B]uffers' },
            { '<leader>sb', '<cmd>FzfLua lgrep_curbuf<cr>', desc = 'Fuzzily [S]earch in current [B]uffer' },

            -- files
            { '<leader>ff', '<cmd>FzfLua files<cr>', desc = '[F]ind [F]iles (root dir)' },
            { '<leader>fF', "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h'), })<cr>", desc = '[F]ind [F]iles (cwd)' },
            { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = '[F]iles [R]ecent' },
            { '<leader>sf', Util.fzf('live_grep_glob'), desc = '[S]earch in [F]iles (root dir)' },
            { '<leader>sF', Util.fzf('live_grep_glob', { cwd = vim.fn.expand('%:p:h') }), desc = '[S]earch in [F]iles (cwd)' },

            -- git
            { '<leader>gc', '<cmd>FzfLua git_commits<CR>', desc = '[G]it [C]ommits' },
            { '<leader>gb', '<cmd>FzfLua git_branches<CR>', desc = '[G]it [B]ranches' },

            -- search
            { '<leader>sw', '<cmd>FzfLua grep_cword <CR>', desc = 'Search current Word (root dir)' },
            { '<leader>sw', '<cmd>FzfLua grep_visual<CR>', mode = 'v', desc = 'Search current Selection (root dir)' },

            -- diagnostics
            { '<leader>xd', '<cmd>FzfLua diagnostics_document<cr>', desc = '[D]ocument [D]iagnostics' },
            { '<leader>xw', '<cmd>FzfLua diagnostics_workspace<cr>', desc = '[W]orkspace [D]iagnostics' },
        },
        opts = function()
            local utils = require('fzf-lua').utils
            local actions = require('fzf-lua.actions')

            local function hl_validate(hl)
                return not utils.is_hl_cleared(hl) and hl or nil
            end

            return {
                file_icon_padding = ' ',
                fzf_opts = {
                    ['--layout'] = 'reverse',
                    ['--marker'] = '+',
                },
                winopts = {
                    height = 0.85,
                    width = 0.7,
                    preview = {
                        hidden = 'nohidden',
                        vertical = 'up:45%',
                        horizontal = 'down:60%',
                        wrap = 'wrap',
                        layout = 'flex',
                        flip_columns = 120,
                        scrollbar = 'float',
                    },
                },
                hls = {
                    normal = hl_validate('TelescopeNormal'),
                    border = hl_validate('TelescopeBorder'),
                    title = hl_validate('TelescopeTitle'),
                    help_normal = hl_validate('TelescopeNormal'),
                    help_border = hl_validate('TelescopeBorder'),
                    preview_normal = hl_validate('TelescopeNormal'),
                    preview_border = hl_validate('TelescopeBorder'),
                    preview_title = hl_validate('TelescopeTitle'),
                    -- builtin preview only
                    cursor = hl_validate('Cursor'),
                    cursorline = hl_validate('TelescopePreviewLine'),
                    cursorlinenr = hl_validate('TelescopePreviewLine'),
                    search = hl_validate('IncSearch'),
                },
                fzf_colors = {
                    ['fg'] = { 'fg', 'TelescopeNormal' },
                    ['bg'] = { 'bg', 'TelescopeNormal' },
                    ['hl'] = { 'fg', 'TelescopeMatching' },
                    ['fg+'] = { 'fg', 'TelescopeSelection' },
                    ['bg+'] = { 'bg', 'TelescopeSelection' },
                    ['hl+'] = { 'fg', 'TelescopeMatching' },
                    ['info'] = { 'fg', 'TelescopeMultiSelection' },
                    ['border'] = { 'fg', 'TelescopeBorder' },
                    ['gutter'] = { 'bg', 'TelescopeNormal' },
                    ['prompt'] = { 'fg', 'TelescopePromptPrefix' },
                    ['pointer'] = { 'fg', 'TelescopeSelectionCaret' },
                    ['marker'] = { 'fg', 'TelescopeSelectionCaret' },
                    ['header'] = { 'fg', 'TelescopeTitle' },
                },
                keymap = {
                    builtin = {
                        ['<C-->'] = 'toggle-fullscreen',
                        -- Only valid with the 'builtin' previewer
                        ['<C-p>'] = 'toggle-preview',
                        ['<C-u>'] = 'preview-page-up',
                        ['<C-d>'] = 'preview-page-down',
                    },
                    fzf = {
                        ['ctrl-a'] = 'beginning-of-line',
                        ['ctrl-e'] = 'end-of-line',
                        ['alt-a'] = 'select-all+accept',
                        -- Only valid with fzf previewers (bat/cat/git/etc)
                        ['ctrl-p'] = 'toggle-preview',
                        ['ctrl-u'] = 'preview-half-page-up',
                        ['ctrl-d'] = 'preview-half-page-down',
                    },
                },
                actions = {
                    files = {
                        ['default'] = actions.file_edit_or_qf,
                        ['ctrl-s'] = actions.file_split,
                        ['ctrl-v'] = actions.file_vsplit,
                        -- copy selected entries to register
                        ['ctrl-y'] = function(selected, opts)
                            vim.fn.setreg('+', selected)
                        end,
                        ['ctrl-q'] = actions.file_sel_to_qf,
                    },
                },
                buffers = {
                    fzf_opts = {
                        ['--delimiter'] = "' '",
                        ['--with-nth'] = '-1..',
                    },
                },
                files = {
                    prompt = 'Files> ',
                    cwd_prompt = false,
                    -- debug = true,
                    cmd = "rg --color=never --files --sort=accessed --hidden --follow -g '!.git'",
                    -- fzf_opts = { ["--tiebreak"] = "index" },
                },
                grep = {
                    debug = false,
                    rg_glob = true,
                    rg_opts = '--hidden --column --line-number --no-heading'
                        .. " --color=always --smart-case -g '!.git' -e",
                    fzf_opts = {
                        ['--history'] = vim.fn.shellescape(
                            vim.fn.stdpath('data') .. '/fzf_search_hist'
                        ),
                    },
                },
                builtin = {
                    winopts = {
                        height = 0.5,
                        width = 0.6,
                        preview = {
                            hidden = 'hidden',
                        },
                    },
                },
                commands = {
                    winopts = {
                        height = 0.5,
                        width = 0.6,
                        preview = {
                            hidden = 'hidden',
                        },
                    },
                },
                git = {
                    branches = {
                        winopts = {
                            height = 0.5,
                            width = 0.6,
                            preview = {
                                hidden = 'hidden',
                            },
                        },
                    },
                },
                lsp = {
                    finder  = {
                        providers = {
                            { "definitions",     prefix = utils.ansi_codes.green("def ") },
                            { "declarations",    prefix = utils.ansi_codes.magenta("decl") },
                            { "implementations", prefix = utils.ansi_codes.green("impl") },
                            { "typedefs",        prefix = utils.ansi_codes.red("tdef") },
                            { "references",      prefix = utils.ansi_codes.blue("ref ") },
                            { "incoming_calls",  prefix = utils.ansi_codes.cyan("in  ") },
                            { "outgoing_calls",  prefix = utils.ansi_codes.yellow("out ") },
                        },
                    },
                    symbols = {
                        path_shorten = 1,
                        symbol_icons = {
                            Namespace = ' ',
                            Method = ' ',
                            Function = ' ',
                            Constructor = ' ',
                            Field = ' ',
                            Variable = ' ',
                            Class = ' ',
                            Interface = ' ',
                            Module = ' ',
                            Property = ' ',
                            Enum = ' ',
                            File = ' ',
                            EnumMember = ' ',
                            Constant = ' ',
                            Struct = ' ',
                            Event = ' ',
                            Operator = ' ',
                            TypeParameter = ' ',
                            Object = ' ',
                            Array = '[]',
                            Boolean = ' ',
                            Number = ' ',
                            Null = 'ﳠ',
                            String = ' ',
                            Package = '',
                        },
                    }
                },
            }
        end,
        -- stylua: ignore end
        config = function(_, opts)
            require('fzf-lua').setup(opts)
            require('fzf-lua').register_ui_select(function(_, items)
                local min_h, max_h = 0.15, 0.70
                local h = (#items + 4) / vim.o.lines
                if h < min_h then
                    h = min_h
                elseif h > max_h then
                    h = max_h
                end
                return { winopts = { height = h, width = 0.60, row = 0.40 } }
            end)
        end,
    },

    -- Fuzzy Finder
    --
    -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    -- {
    --     'nvim-telescope/telescope.nvim',
    --     tag = '0.1.2',
    --     cmd = 'Telescope',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-treesitter/nvim-treesitter',
    --         'nvim-tree/nvim-web-devicons',
    --     },
        -- stylua: ignore
        -- keys = {
        --     -- general
        --     { '<leader>?', '<cmd>Telescope builtin<cr>', desc = '[?] Built-in' },
        --     { '<leader>:', '<cmd>Telescope commands<cr>', desc = '[:] Commands' },
        --
        --     -- buffers
        --     { '<leader>b', '<cmd>Telescope buffers<cr>', desc = '[B]uffers' },
        --     { '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Fuzzily [S]earch in current [B]uffer' },
        --
        --     -- files
        --     { '<leader>ff', Util.telescope('files'), desc = '[F]ind [F]iles (root dir)' },
        --     { '<leader>fF', "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h'), })<cr>", desc = '[F]ind [F]iles (cwd)' },
        --     { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = '[F]iles [R]ecent' },
        --     { '<leader>sf', Util.telescope('live_grep'), desc = '[S]earch in [F]iles (root dir)' },
        --     { '<leader>sF', Util.telescope('live_grep', { cwd = vim.fn.expand('%:p:h') }), desc = '[S]earch in [F]iles (cwd)' },
        --
        --     -- git
        --     { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = '[G]it [C]ommits' },
        --     { '<leader>gb',  '<cmd>Telescope git_branches<CR>', desc = '[G]it [B]ranches' },
        --
        --     -- workflow
        --     { '<leader>m', '<cmd>Telescope harpoon marks<cr>', desc = 'Jump to Mark' },
        --
        --     -- search
        --     { '<leader>sw', Util.telescope('grep_string', { word_match = '-w' }), desc = 'Search current Word (root dir)' },
        --     { '<leader>sw', Util.telescope('grep_string'), mode = 'v', desc = 'Search current Selection (root dir)' },
        --
        --     -- diagnostics
        --     { '<leader>xd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = '[D]ocument [D]iagnostics' },
        --     { '<leader>xD', '<cmd>Telescope diagnostics<cr>', desc = '[W]orkspace [D]iagnostics' },
        --
        --     -- undo
        --     { '<leader>u', '<cmd>Telescope undo<cr>', desc = '[Undo] tree' },
        -- },
        -- config = function(_, opts)
        --     require('telescope').setup({
        --         defaults = {
        --             initial_mode = 'insert',
        --             select_strategy = 'reset',
        --             sorting_strategy = 'ascending',
        --             layout_strategy = 'vertical',
        --             layout_config = {
        --                 flex = {
        --                     flip_columns = 120,
        --                 },
        --                 horizontal = {
        --                     prompt_position = 'top',
        --                     width = 0.8,
        --                     height = 0.3,
        --                     preview_width = 0.5,
        --                 },
        --                 vertical = {
        --                     prompt_position = 'top',
        --                     width = 0.5,
        --                     height = 0.8,
        --                     mirror = true,
        --                     preview_cutoff = 0,
        --                 },
        --             },
        --             -- stylua: ignore
        --             mappings = {
        --                 n = {
        --                     ['<c-p>'] = require('telescope.actions.layout').toggle_preview,
        --                 },
        --                 i = {
        --                     ['<c-t>'] = function(...)
        --                         return require('trouble.providers.telescope').smart_open_with_trouble(...)
        --                     end,
        --                     ['<c-p>'] = require('telescope.actions.layout').toggle_preview,
        --                     ['<c-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
        --                 },
        --             },
        --         },
        --         pickers = {
        --             git_branches = {
        --                 theme = 'dropdown',
        --                 previewer = false,
        --                 layout_config = {
        --                     width = 0.5,
        --                 },
        --             },
        --             commands = {
        --                 theme = 'dropdown',
        --                 previewer = false,
        --                 layout_config = {
        --                     width = 0.5,
        --                 },
        --             },
        --         },
        --         extensions = {
        --             fzf = {
        --                 fuzzy = true, -- false will only do exact matching
        --                 override_generic_sorter = true, -- override the generic sorter
        --                 override_file_sorter = true, -- override the file sorter
        --                 case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        --             },
        --         },
        --     })

            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
    --         require('telescope').load_extension('fzf')
    --     end,
    -- },

    -- Harpoon
    --
    {
        'theprimeagen/harpoon',
        config = function()
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')

            vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)
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

    -- Better diagnostics list
    --
    {
        'folke/trouble.nvim',
        -- stylua: ignore start
        keys = {
            { '<leader>xx', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix [D]iagnostics' },
        },
        -- stylua: ignore end
        opts = {
            use_diagnostic_signs = true,
        },
    },

    -- UndoTree
    --
    {
        'mbbill/undotree',
        config = true,
        keys = {
            { '<leader>u', vim.cmd.UndotreeToggle, desc = '[Undo] tree' },
        },
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
                            colwidth = 2,
                            auto = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    {
                        sign = {
                            namespace = { '.*' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = true,
                        },
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
        enable = false,
        event = { 'UIEnter' },
        opts = {
            chunk = {
                exclude_filetypes = {
                    fzf = true,
                },
            },
            indent = { enable = false },
            line_num = { enable = false },
            blank = { enable = false },
        },
    },

    -- TODO Comments
    --
    {
        'folke/todo-comments.nvim',
        dependencies = { 'folke/trouble.nvim' },
        cmd = { 'TodoTrouble' },
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            signs = false,
        },
        -- stylua: ignore
        keys = {
            { "<leader>st", "<cmd>TodoTrouble<cr>", desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        },
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

    -- Automatically highlights other instances of the word under your cursor.
    -- This works with LSP, Treesitter, and regexp matching to find the other
    -- instances.
    {
        'RRethy/vim-illuminate',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            providers = {
                'lsp',
                'treesitter',
                'regex',
            },
            delay = 200,
            filetypes_denylist = {
                'oil',
                'fugitive',
                'qf',
                'TelescopePrompt',
                'Trouble',
                'DiffviewFiles',
                'DiffviewFileHistory',
            },
            large_file_cutoff = 2000,
            large_file_overrides = {
                providers = {
                    'lsp',
                },
            },
        },
        config = function(_, opts)
            require('illuminate').configure(opts)

            local function map(key, dir, buffer)
                vim.keymap.set('n', key, function()
                    require('illuminate')['goto_' .. dir .. '_reference'](false)
                end, {
                    desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
                    buffer = buffer,
                })
            end
            local bufnr = vim.api.nvim_get_current_buf()

            map(']]', 'next', bufnr)
            map('[[', 'prev', bufnr)
            --
            --     -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            --     vim.api.nvim_create_autocmd('FileType', {
            --         pattern = require('illuminate').
            --         callback = function()
            --             local buffer = vim.api.nvim_get_current_buf()
            --             map(']]', 'next', buffer)
            --             map('[[', 'prev', buffer)
            --         end,
            -- })
        end,
        -- keys = {
        --     { ']]', desc = 'Next Reference' },
        --     { '[[', desc = 'Prev Reference' },
        -- },
    },

    -- Testing framework
    --
    {
        'vim-test/vim-test',
        config = function()
            vim.g['test#strategy'] = 'neovim'
            vim.g['test#neovim#start_normal'] = '1'
        end,
    },
}
