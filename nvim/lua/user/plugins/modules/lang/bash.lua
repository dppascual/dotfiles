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

    -- Add formatters
    --
    {
        'stevearc/conform.nvim',
        dependencies = { 'mason.nvim' },
        opts = {
            formatters_by_ft = {
                sh = { 'shfmt' },
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
