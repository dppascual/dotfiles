return {

    -- Playground for treesitter
    --
    { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },

    -- Treesitter Context
    --
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'BufReadPre',
        opts = { mode = 'cursor', max_lines = 3 },
    },

    -- Highlight, edit, and navigate code
    --
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate',
        event = { 'VeryLazy' },
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                config = function()
                    -- When in diff mode, we want to use the default
                    -- vim text objects c & C instead of the treesitter ones.
                    local move = require('nvim-treesitter.textobjects.move') ---@type table<string,fun(...)>
                    local configs = require('nvim-treesitter.configs')
                    for name, fn in pairs(move) do
                        if name:find('goto') == 1 then
                            move[name] = function(q, ...)
                                if vim.wo.diff then
                                    local config = configs.get_module(
                                        'textobjects.move'
                                    )[name] ---@type table<string,string>
                                    for key, query in pairs(config or {}) do
                                        if
                                            q == query
                                            and key:find('[%]%[][cC]')
                                        then
                                            vim.cmd('normal! ' .. key)
                                            return
                                        end
                                    end
                                end
                                return fn(q, ...)
                            end
                        end
                    end
                end,
            },
        },
        opts = {
            ---@type table - filled up by each language module
            ensure_installed = {},
            highlight = {
                enable = true,
                -- Disable slow treesitter highlight for large files
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats =
                        pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<space><space>', -- maps in normal mode to init the node/scope selection with space
                    node_incremental = '<space><space>', -- increment to the upper named parent
                    node_decremental = '<bs>', -- decrement to the previous node
                    scope_incremental = '<tab>', -- increment to the upper scope (as defined in locals.scm)
                },
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = true, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['at'] = '@class.outer',
                        ['it'] = '@class.inner',
                        ['ac'] = '@comment.outer',
                        ['ic'] = '@comment.inner',
                        ['iB'] = '@block.inner',
                        ['aB'] = '@block.outer',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']t'] = '@class.outer',
                        [']a'] = '@parameter.inner',
                    },
                    goto_next_end = {
                        [']F'] = '@function.outer',
                        [']T'] = '@class.outer',
                        [']A'] = '@parameter.inner',
                    },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[t'] = '@class.outer',
                        ['[a'] = '@parameter.inner',
                    },
                    goto_previous_end = {
                        ['[F'] = '@function.outer',
                        ['[T'] = '@class.outer',
                        ['[A'] = '@parameter.inner',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>sa'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>sA'] = '@parameter.inner',
                    },
                },
            },
        },
        config = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                ---@type table<string, boolean>
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require('nvim-treesitter.configs').setup(opts)

            local ts_repeat_move =
                require('nvim-treesitter.textobjects.repeatable_move')

            -- Repeat movement with ; and ,
            -- ensure ; goes forward and , goes backward regardless of the last direction
            vim.keymap.set(
                { 'n', 'x', 'o' },
                ';',
                ts_repeat_move.repeat_last_move_next
            )
            vim.keymap.set(
                { 'n', 'x', 'o' },
                ',',
                ts_repeat_move.repeat_last_move_previous
            )

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
            vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
            vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
            vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
        end,
    },
}
