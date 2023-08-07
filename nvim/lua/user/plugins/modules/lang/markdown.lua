return {
    -- Add markdown to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, {
                    'markdown',
                    'markdown_inline',
                })
            end
        end,
    },

    -- Correctly setup lspconfig for markdown
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                marksman = {},
            },
        },
    },
}