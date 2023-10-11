return {
    -- Add dockerfile to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'dockerfile' })
            end
        end,
    },

    -- Add linters
    --
    {
        'mfussenegger/nvim-lint',
        dependencies = {
            'mason.nvim',
            opts = function(_, opts)
                opts.ensure_installed = opts.ensure_installed or {}
                vim.list_extend(opts.ensure_installed, { 'hadolint' })
            end,
        },
        opts = {
            linters_by_ft = {
                dockerfile = { 'hadolint' },
            },
        },
    },

    -- Correctly setup lspconfig for docker
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                dockerls = {},
                docker_compose_language_service = {},
            },
        },
    },
}
