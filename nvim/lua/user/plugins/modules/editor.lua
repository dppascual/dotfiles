local Util = require('user.util')

return {
    -- File explorer
    --
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            default_file_explorer = true,
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
        cmd = 'FzfLua',
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
            { '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', desc = '[D]ocument [D]iagnostics' },
            { '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = '[W]orkspace [D]iagnostics' },
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
                        horizontal = 'up:60%',
                        wrap = 'wrap',
                        layout = 'flex',
                        flip_columns = 120,
                        scrollbar = 'float',
                    },
                },
                hls = {
                    normal = hl_validate('TelescopeNormal'),
                    -- border = hl_validate('TelescopeBorder'),
                    title = hl_validate('TelescopeTitle'),
                    help_normal = hl_validate('TelescopeNormal'),
                    -- help_border = hl_validate('TelescopeBorder'),
                    preview_normal = hl_validate('TelescopeNormal'),
                    -- preview_border = hl_validate('TelescopeBorder'),
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
                    -- ['border'] = { 'fg', 'TelescopeBorder' },
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
                    -- cmd = "rg --color=always --files --ignore-case --sort=accessed --hidden --follow -g '!.git'",
                    fzf_opts = { ["--tiebreak"] = "index" },
                },
                grep = {
                    rg_glob = true,
                    glob_flag = "--iglob",
                    glob_separator = "%s%-%-",
                    rg_opts = "--sort-files --hidden --column --line-number --no-heading " ..
                        "--color=always --ignore-case -g '!.git'",
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
                    commits = {
                        actions = {
                            ['ctrl-y'] = { fn = function(selected, _)
                                local commit_hash = selected[1]:match("[^ ]+")
                                vim.fn.setreg([[+]], commit_hash)
                            end,
                                exec_silent = true,
                            }
                        }
                    }
                },
                lsp = {
                    symbols = {
                        fzf_opts = {
                             ["--delimiter"] = "'[:]'",
                            ["--with-nth"]  = "4..",
                        },
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
    -- {
    --     'RRethy/vim-illuminate',
    --     event = { 'BufReadPost', 'BufNewFile' },
    --     opts = {
    --         providers = {
    --             'lsp',
    --             'treesitter',
    --             'regex',
    --         },
    --         delay = 200,
    --         filetypes_denylist = {
    --             'oil',
    --             'fugitive',
    --             'qf',
    --             'TelescopePrompt',
    --             'Trouble',
    --             'DiffviewFiles',
    --             'DiffviewFileHistory',
    --         },
    --         large_file_cutoff = 2000,
    --         large_file_overrides = {
    --             providers = {
    --                 'lsp',
    --             },
    --         },
    --     },
    --     config = function(_, opts)
    --         require('illuminate').configure(opts)
    --
    --         local function map(key, dir, buffer)
    --             vim.keymap.set('n', key, function()
    --                 require('illuminate')['goto_' .. dir .. '_reference'](false)
    --             end, {
    --                 desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
    --                 buffer = buffer,
    --             })
    --         end
    --         local bufnr = vim.api.nvim_get_current_buf()
    --
    --         map(']]', 'next', bufnr)
    --         map('[[', 'prev', bufnr)
    --         --
    --         --     -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    --         --     vim.api.nvim_create_autocmd('FileType', {
    --         --         pattern = require('illuminate').
    --         --         callback = function()
    --         --             local buffer = vim.api.nvim_get_current_buf()
    --         --             map(']]', 'next', buffer)
    --         --             map('[[', 'prev', buffer)
    --         --         end,
    --         -- })
    --     end,
    --     -- keys = {
    --     --     { ']]', desc = 'Next Reference' },
    --     --     { '[[', desc = 'Prev Reference' },
    --     -- },
    -- },

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
