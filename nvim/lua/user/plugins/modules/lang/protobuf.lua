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

    -- Binares required by formatters and linters
    --
    {
        'mason.nvim',
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { 'buf' })
        end,
    },

    -- Add formatters
    --
    {
        'stevearc/conform.nvim',
        dependencies = { 'mason.nvim' },
        opts = {
            formatters_by_ft = {
                proto = { 'buf' },
            },
        },
    },

    -- Add linters
    --
    {
        'mfussenegger/nvim-lint',
        dependencies = { 'mason.nvim' },
        opts = {
            linters_by_ft = {
                proto = { 'buf_lint' },
            },
        },
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
