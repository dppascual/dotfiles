local M = {}

M.on_attach = function(client, bufnr)
    local group = vim.api.nvim_create_augroup('LSP', { clear = true })

    -- Enable inlay-hints
    --
    if client.server_capabilities.inlayHintProvider then
        vim.api.nvim_create_autocmd('InsertEnter', {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint(bufnr, false)
            end,
            group = 'LSP',
        })
        vim.api.nvim_create_autocmd({ 'BufReadPre', 'InsertLeave' }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint(bufnr, true)
            end,
            group = 'LSP',
        })
    end

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

    keymapFn('gd', ':Glance definitions', { desc = '[G]oto [D]efinition' })
    keymapFn('gr', ':Glance references', { desc = '[G]oto [R]eferences' })
    keymapFn(
        'gi',
        ':Glance implementations',
        { desc = '[G]oto [I]mplementation' }
    )
    keymapFn(
        'gt',
        ':Glance type_definitions',
        { desc = '[G]oto [T]ype Definition' }
    )
    keymapFn('K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
    keymapFn(
        '<C-k>',
        vim.lsp.buf.signature_help,
        { desc = 'Signature Help', mode = { 'i', 'n' } }
    )
    keymapFn(
        '<leader>ds',
        "lua require'telescope.builtin'.lsp_document_symbols()",
        { desc = 'Document [S]ymbols' }
    )
    keymapFn(
        '<leader>ws',
        "lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()",
        { desc = 'Workspace [S]ymbols' }
    )

    if client.server_capabilities.renameProvider then
        keymapFn('<leader>r', vim.lsp.buf.rename, { desc = '[R]ename' })
    end

    if client.server_capabilities.codeActionProvider then
        keymapFn(
            '<leader>ca',
            vim.lsp.buf.code_action,
            { desc = 'Code [A]ction', mode = { 'n', 'v' } }
        )

        keymapFn('<leader>cA', function()
            vim.lsp.buf.code_action({
                context = {
                    only = {
                        'source',
                    },
                    diagnostics = {},
                },
            })
        end, { desc = 'Code [A]ction', mode = { 'n', 'v' } })
    end

    -- Lesser used LSP functionality
    -- Workspaces
    --
    keymapFn(
        '<leader>wa',
        vim.lsp.buf.add_workspace_folder,
        { desc = '[W]orkspace [A]dd Folder' }
    )
    keymapFn(
        '<leader>wr',
        vim.lsp.buf.remove_workspace_folder,
        { desc = '[W]orkspace [R]emove Folder' }
    )
    keymapFn('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = '[W]orkspace [L]ist Folders' })

    -- Formatting
    --
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    filter = function(cli)
                        return cli.name ~= 'sumneko_lua'
                    end,
                    bufnr = bufnr,
                })
            end,
            group = group,
        })
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        keymapFn(
            'gq',
            vim.lsp.buf.format,
            { mode = 'v', desc = '[gq] Format Range' }
        )
    end

    -- CodeLens
    --
    if client.server_capabilities.codeLensProvider then
        keymapFn(
            '<leader>cl',
            vim.lsp.codelens.run,
            { mode = 'n', desc = '[C]ode[Lens]' }
        )

        vim.api.nvim_create_autocmd(
            { 'BufEnter', 'CursorHold', 'InsertLeave' },
            {
                buffer = bufnr,
                callback = function()
                    vim.lsp.codelens.refresh()
                end,
                group = group,
            }
        )

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
end

return M
