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
        border = 'rounded',
        source = 'always',
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

keymapFn(
    ']d',
    'lua vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN }, float = false })',
    { desc = 'Next Diagnostic' }
)
keymapFn(
    '[d',
    'lua vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN }, float = false })',
    { desc = 'Prev Diagnostic' }
)
keymapFn(
    '<leader>l',
    require('lsp_lines').toggle,
    { desc = 'Toggle lsp_lines' }
)

-- Diagnostic autocmd
-- vim.api.nvim_create_autocmd('CursorHold', {
--     pattern = { '*' },
--     command = 'lua vim.diagnostic.open_float(nil, { focusable = false })',
-- })
