local M = {}

M.on_attach = function(client, bufnr)
    local group = vim.api.nvim_create_augroup('LSP', { clear = true })

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

    -- stylua: ignore start
    keymapFn('gd', ':Glance definitions', { desc = '[G]oto [D]efinition' })
    keymapFn('gr', ':Glance references', { desc = '[G]oto [R]eferences' })
    keymapFn( 'gi', ':Glance implementations', { desc = '[G]oto [I]mplementation' })
    keymapFn( 'gy', ':Glance type_definitions', { desc = '[G]oto [T]ype Definition' })
    keymapFn('K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
    keymapFn( '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Help', mode = { 'i', 'n' } })
    keymapFn( '<leader>ss', ':FzfLua lsp_document_symbols', { desc = '[D]ocument [S]ymbols' })
    keymapFn( '<leader>sS', ':FzfLua lsp_live_workspace_symbols', { desc = '[W]orkspace [S]ymbols' })

    if client.supports_method('textDocument/rename') then
        keymapFn('<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename' })
    end

    if client.supports_method('textDocument/codeAction') then
        keymapFn( '<leader>ca', ':CodeActionMenu', { desc = 'Code [A]ction', mode = { 'n', 'v' } })
        keymapFn('<leader>cA', function()
            vim.lsp.buf.code_action({context = {only = { 'source' }, diagnostics = {}}})
        end, { desc = 'Code [A]ction', mode = { 'n', 'v' } })
    end

    -- Lesser used LSP functionality
    -- Workspaces
    --
    keymapFn( '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = '[W]orkspace [A]dd Folder' })
    keymapFn( '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = '[W]orkspace [R]emove Folder' })
    keymapFn('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = '[W]orkspace [L]ist Folders' })

    -- Formatting (deprecated in favor of conform.nvim)
    --
    -- if client.supports_method('textDocument/formatting') then
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --         buffer = bufnr,
    --         callback = function()
    --             vim.lsp.buf.format({
    --                 filter = function(clt)
    --                     return clt.name == 'null-ls'
    --                 end,
    --                 bufnr = bufnr,
    --             })
    --         end,
    --         group = group,
    --     })
    -- end

    -- CodeLens
    --
    if client.supports_method('textDocument/codeLens') then
        keymapFn( '<leader>cl', vim.lsp.codelens.run, { mode = 'n', desc = '[C]ode[Lens]' })

        vim.api.nvim_create_autocmd(
            { 'BufEnter', 'CursorHold', 'InsertLeave' },
            {
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh,
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
    if client.supports_method('textDocument/documentHighlight') then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
            group = group,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
            group = group,
        })
    end
    -- stylua: ignore end
end

return M
