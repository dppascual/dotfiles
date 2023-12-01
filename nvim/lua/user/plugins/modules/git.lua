return {
    -- Git plugins
    --
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = {
                    hl = 'GitSignsAdd',
                    text = '▍',
                    numhl = 'GitSignsAddNr',
                    linehl = 'GitSignsAddLn',
                },
                change = {
                    hl = 'GitSignsChange',
                    text = '▍',
                    numhl = 'GitSignsChangeNr',
                    linehl = 'GitSignsChangeLn',
                },
                delete = {
                    hl = 'GitSignsDelete',
                    text = '▍',
                    numhl = 'GitSignsDeleteNr',
                    linehl = 'GitSignsDeleteLn',
                },
                changedelete = {
                    hl = 'GitSignsChange',
                    text = '▍',
                    numhl = 'GitSignsChangeNr',
                    linehl = 'GitSignsChangeLn',
                },
                topdelete = {
                    hl = 'GitSignsDelete',
                    text = '',
                    numhl = 'GitSignsDeleteNr',
                    linehl = 'GitSignsDeleteLn',
                },
                untracked = {
                    hl = 'GitSignsUntracked',
                    text = '',
                    numhl = 'GitSignsUntrackedNr',
                    linehl = 'GitSignsUntrackedLn',
                },
            },
            signcolumn = true,
            numhl = true,
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            preview_config = {
                -- Options passed to nvim_open_win
                border = CUSTOM_BORDER,
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = vim.tbl_deep_extend(
                        'keep',
                        opts,
                        { noremap = true, silent = true }
                    )
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- stylua: ignore start
                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = "Next Hunk" })

                map('n', '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = "Prev Hunk"})

                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage Selection Hunk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset Selection Hunk" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
                map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Preview Hunk" })
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
            end,
        },
    },
    {
        'tpope/vim-fugitive',
        event = 'VeryLazy',
        keys = {
            {
                '<leader>gs',
                '<cmd>vertical Git<cr>',
                desc = 'Git Status',
            },
        },
    },
    {
        'sindrets/diffview.nvim',
        cmd = {
            'DiffviewOpen',
            'DiffviewFileHistory',
        },
        opts = {
            -- default_args = { -- Default args prepended to the arg-list for the listed commands
            --     DiffviewOpen = { '--imply-local' },
            -- },
            hooks = {
                diff_buf_read = function(_)
                    vim.opt_local.relativenumber = false
                end,
            },
        },
    },
    {
        'rhysd/git-messenger.vim',
        keys = {
            {
                '<leader>gm',
                '<cmd>GitMessenger<cr>',
                desc = 'Reveal a Git message under the cursor',
            },
        },
        config = function()
            vim.g.git_messenger_floating_win_opts = {
                border = CUSTOM_BORDER,
            }
        end,
    },
}
