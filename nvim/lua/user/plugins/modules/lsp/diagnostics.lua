-- Diagnostic config
vim.diagnostic.config({
    -- virtual_text = { spacing = 4, prefix = '●' },
    virtual_text = false,
    virtual_lines = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = 'minimal',
        border = CUSTOM_BORDER,
        source = 'if_many',
        header = '',
        prefix = '',
    },
})

-- Diagnostic keymaps
local function keymapFn(lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(
        opts.mode or 'n',
        lhs,
        type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
        { noremap = true, silent = true, desc = opts.desc }
    )
end

-- stylua: ignore start
keymapFn( ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
keymapFn( '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
keymapFn( ']e', 'lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })', { desc = 'Next Error' })
keymapFn( '[e', 'lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })', { desc = 'Prev Error' })
-- keymapFn(
--     '<leader>xl',
--     require('lsp_lines').toggle,
--     { desc = 'Toggle lsp_lines' }
-- )

-- Diagnostic keymap
keymapFn( '<leader>cd', 'lua vim.diagnostic.open_float(nil, { focusable = true })', { desc = 'Open float diagnostic' })
-- vim.api.nvim_create_autocmd('CursorHold', {
--     pattern = { '*' },
--     command = 'lua vim.diagnostic.open_float(nil, { focusable = false })',
-- })
-- stylua: ignore end
