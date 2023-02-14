local helpers = {}

-- Taken from here: https://github.com/neovim/nvim-lspconfig/issues/115
helpers.organizeImports = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local opts = {
    client = vim.lsp.get_active_clients({
      bufnr = bufnr,
    })[1],
    bufnr = bufnr,
    wait_ms = 1500,
  }
  local params = vim.lsp.util.make_range_params(nil, opts.client.offset_encoding)
  params.context = { only = { "source.organizeImports" } }

  local result = vim.lsp.buf_request_sync(opts.bufnr, "textDocument/codeAction", params, opts.wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, opts.client.offset_encoding)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

helpers.format_lsp = function()
  local buf = vim.api.nvim_get_current_buf()

  vim.lsp.buf.format {
    -- Never request sumneko_lua for formatting
    filter = function(client)
      return client.name ~= "sumneko_lua"
    end,
    bufnr = buf,
  }
end

return helpers
