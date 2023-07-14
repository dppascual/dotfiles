return {
    -- Add yaml to treesitter
    --
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'yaml' })
            end
        end,
    },

    -- Correctly setup lspconfig for yaml
    --
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                yamlls = {
                    settings = {
                        yaml = {
                            schemaStore = {
                                url = 'https://www.schemastore.org/api/json/catalog.json',
                                enable = true,
                            },
                        },
                    },
                },
            },
        },
    },
}
