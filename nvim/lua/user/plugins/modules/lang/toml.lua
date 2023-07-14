return {
    -- Add toml to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'toml' })
            end
        end,
    },

    -- Correctly setup lspconfig for toml
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                taplo = {
                    keys = {
                        {
                            'K',
                            function()
                                if
                                    vim.fn.expand('%:t') == 'Cargo.toml'
                                    and require('crates').popup_available()
                                then
                                    require('crates').show_popup()
                                else
                                    vim.lsp.buf.hover()
                                end
                            end,
                            desc = 'Show Crate Documentation',
                        },
                    },
                },
            },
        },
    },
}
