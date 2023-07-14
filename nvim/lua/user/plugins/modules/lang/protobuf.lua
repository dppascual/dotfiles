return {
    -- Add protobuf to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'proto' })
            end
        end,
    },

    -- Correctly setup lspconfig for proto
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                bufls = {},
            },
        },
    },
}
