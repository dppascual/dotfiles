return {
    -- Add bash to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'bash' })
            end

            -- Register zsh
            vim.treesitter.language.register('bash', 'zsh')
        end,
    },

    -- Binares required by formatters and linters
    --
    {
        'mason.nvim',
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { 'shfmt' })
        end,
    },

    -- Add formatters
    --
    {
        'stevearc/conform.nvim',
        dependencies = { 'mason.nvim' },
        opts = {
            formatters_by_ft = {
                sh = { 'shfmt' },
                fish = { 'fish_indent' },
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
                fish = { 'fish' },
            },
        },
    },

    -- Correctly setup lspconfig for bash
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                bashls = {
                    filetypes = { 'sh', 'zsh', 'bash' },
                },
            },
        },
    },
}
