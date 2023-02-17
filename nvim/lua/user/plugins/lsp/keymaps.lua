local group = vim.api.nvim_create_augroup('LSP', { clear = true })
local inlay_hints = require('lsp-inlayhints')

inlay_hints.setup({
    inlay_hints = {
        -- Only show inlay hints for the current line
        only_current_line = false,

        parameter_hints = {
            show = true,
            prefix = ' <- ',
            separator = ', ',
            remove_colon_start = false,
            remove_colon_end = true,
        },

        type_hints = {
            -- type and other hints
            show = true,
            prefix = ' => ',
            separator = ', ',
            remove_colon_start = false,
            remove_colon_end = false,
        },

        labels_separator = '  ',
        highlight = 'Whitespace',
    },
})

local M = {}

M.on_attach = function(client, bufnr)
    -- Enable inlay-hints
    --
    inlay_hints.on_attach(client, bufnr, false)

    -- Keymaps
    --
    local function keymapFn(lhs, rhs, opts)
        opts = opts or {}
        vim.keymap.set(
            opts.mode or 'n',
            lhs,
            type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
            {
                noremap = true,
                silent = true,
                buffer = bufnr,
                expr = opts.expr,
                desc = opts.desc,
            }
        )
    end

    if client.server_capabilities.renameProvider then
        keymapFn(
            '<leader>rn',
            'lua vim.lsp.buf.rename()',
            { desc = '[R]e[n]ame' }
        )
    end

    if client.server_capabilities.codeActionProvider then
        keymapFn(
            '<leader>ca',
            vim.lsp.buf.code_action,
            { desc = 'Code Action', mode = { 'n', 'v' } }
        )
    end

    keymapFn(
        'gd',
        "lua require('fzf-lua').lsp_definitions({ sync = true, jump_to_single_result = true, ignore_current_line = true })",
        { desc = '[G]oto [D]efinition' }
    )
    keymapFn(
        'gr',
        "lua require('fzf-lua').lsp_references({ sync = true, jump_to_single_result = true, ignore_current_line = true })",
        { desc = '[G]oto [R]eferences' }
    )
    keymapFn(
        'gi',
        "lua require('fzf-lua').lsp_implementations({ sync = true, jump_to_single_result = true, ignore_current_line = true })",
        { desc = '[G]oto [I]mplementation' }
    )
    keymapFn(
        'gt',
        vim.lsp.buf.type_definition,
        { desc = '[G]oto [T]ype Definition' }
    )
    keymapFn('K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
    keymapFn(
        '<C-k>',
        vim.lsp.buf.signature_help,
        { desc = 'Signature Help', mode = { 'i', 'n' }, has = 'signatureHelp' }
    )
    keymapFn('<leader>ds', ':SymbolsOutline', '[D]ocument [S]ymbols')
    keymapFn(
        '<leader>ws',
        require('fzf-lua').lsp_live_workspace_symbols,
        '[W]orkspace [S]ymbols'
    )

    -- Lesser used LSP functionality
    -- Workspaces
    --
    keymapFn(
        '<leader>wa',
        vim.lsp.buf.add_workspace_folder,
        '[W]orkspace [A]dd Folder'
    )
    keymapFn(
        '<leader>wr',
        vim.lsp.buf.remove_workspace_folder,
        '[W]orkspace [R]emove Folder'
    )
    keymapFn('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Formatting
    --
    format_lsp = R('user.plugins.lsp.format').format_lsp
    if client.server_capabilities.documentFormattingProvider then
        keymapFn(
            '<leader>ft',
            string.format('lua format_lsp(%s)', bufnr),
            { desc = '[F]orma[t] Document' }
        )
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                format_lsp(bufnr)
            end,
            group = group,
        })
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        keymapFn(
            '<leader>ft',
            string.format('lua format_lsp(%s)', bufnr),
            { mode = 'v', desc = '[F]orma[t] Range' }
        )
    end

    if
        client.server_capabilities.codeActionProvider
        and client.name == 'gopls'
    then
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            buffer = bufnr,
            callback = function()
                R('user.plugins.lsp.format').organizeImports(
                    client,
                    bufnr,
                    2000
                )
            end,
            group = group,
        })
    end

    -- CodeLens
    --
    if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh()
            end,
            group = group,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
            buffer = bufnr,
            callback = function()
                vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
            end,
            group = group,
        })
    end

    -- DocumentHighlight
    --
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            group = group,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            group = group,
        })
    end

    -- LSP Signature Documentation
    --
    require('lsp_signature').on_attach(client, bufnr)
end

return M
