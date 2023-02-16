local helpers = {}

-- Taken from here: https://github.com/neovim/nvim-lspconfig/issues/115
helpers.organizeImports = function(client, bufnr, wait_ms)
    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = { only = { 'source.organizeImports' } }

    local result = vim.lsp.buf_request_sync(
        bufnr,
        'textDocument/codeAction',
        params,
        wait_ms
    )
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(
                    r.edit,
                    client.offset_encoding
                )
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

helpers.format_lsp = function(bufnr)
    vim.lsp.buf.format({
        -- Never request lua_ls for formatting
        filter = function(client)
            return client.name ~= 'lua_ls'
        end,
        bufnr = bufnr,
    })
end

return helpers
