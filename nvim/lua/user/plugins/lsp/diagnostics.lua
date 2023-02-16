-- Diagnostic sign
local function signFn(opts)
    if not opts then
        return
    end

    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = '',
    })
end

signFn({ name = 'DiagnosticSignError', text = ' ' })
signFn({ name = 'DiagnosticSignWarn', text = ' ' })
signFn({ name = 'DiagnosticSignHint', text = ' ' })
signFn({ name = 'DiagnosticSignInfo', text = ' ' })

-- Diagnostic config
vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = '●' },
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

keymapFn(']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
keymapFn('[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
keymapFn(
    ']e',
    'lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })',
    { desc = 'Next Error' }
)
keymapFn(
    '[e',
    'lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })',
    { desc = 'Prev Error' }
)
keymapFn(
    ']w',
    'lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })',
    { desc = 'Next Warning' }
)
keymapFn(
    '[w',
    'lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })',
    { desc = 'Prev Warning' }
)

-- Diagnostic autocmd
vim.api.nvim_create_autocmd('CursorHold', {
    pattern = { '*' },
    command = 'lua vim.diagnostic.open_float(nil, { focusable = false })',
})
