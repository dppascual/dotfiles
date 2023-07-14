return {
    -- Add bash to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'bash' })
            end
        end,
    },

    -- Add shell formatter to mason
    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = opts.sources or {}
            vim.list_extend(opts.sources, {
                nls.builtins.formatting.shfmt
            })
        end,
        dependencies = {
            "mason.nvim",
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { "shfmt" })
            end,
        },
    },

    -- Correctly setup lspconfig for bash
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                bashls = {},
            },
        },
    },
}
