local editor_group =
    vim.api.nvim_create_augroup('EditorOptions', { clear = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({
            timeout = 500,
        })
    end,
    group = editor_group,
    pattern = '*',
})

-- [[ Show cursor line only in active window ]]
--
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-cursorline')
        if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, 'auto-cursorline')
        end
    end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
    callback = function()
        local cl = vim.wo.cursorline
        if cl then
            vim.api.nvim_win_set_var(0, 'auto-cursorline', cl)
            vim.wo.cursorline = false
        end
    end,
})

-- [[ Show color column only in active window ]]
--
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, 'auto-colorcolumn')
        if ok and cl then
            vim.wo.colorcolumn = cl
            vim.api.nvim_win_del_var(0, 'auto-colorcolumn')
        end
    end,
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    callback = function()
        local cl = vim.wo.colorcolumn
        if cl then
            vim.api.nvim_win_set_var(0, 'auto-colorcolumn', cl)
            vim.wo.colorcolumn = '0'
        end
    end,
})

-- [[ Create missing folders on save ]]
--
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.fn.mkdir(vim.fn.expand('<afile>:p:h'), 'p')
    end,
    group = editor_group,
    pattern = '*',
})

-- [[ Open Oil.nvim when no file is selected on startup]]
--
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        if vim.fn.argv(0) == '' then
            require('fzf-lua').files()
        end
    end,
})

-- [[ No Highlight when leave cmdline ]]
--
-- vim.api.nvim_create_autocmd('CmdlineEnter', {
--     callback = function()
--         vim.opt.hlsearch = true
--         vim.opt.incsearch = true
--     end,
--     group = editor_group,
--     pattern = '/,?',
-- })
--
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--     callback = function()
--         vim.opt.hlsearch = false
--         vim.opt.incsearch = false
--     end,
--     group = editor_group,
--     pattern = '/,?',
-- })

-- [[ Disable statusline in terminal mode ]]
--
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt.laststatus = 0
    end,
    group = editor_group,
    pattern = '*',
})
vim.api.nvim_create_autocmd('TermClose', {
    callback = function()
        vim.opt.laststatus = 3
    end,
    group = editor_group,
    pattern = '*',
})
