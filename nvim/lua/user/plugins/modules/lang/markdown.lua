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

    -- Make markdown previewer better.
    --
    {
        'toppair/peek.nvim',
        build = 'deno task --quiet build:fast',
        opts = {},
        config = function(_, opts)
            local peek = require('peek')
            peek.setup(opts)

            -- User command
            --
            vim.api.nvim_create_user_command('PeekToggle', function()
                if peek.is_open() then
                    peek.close()
                else
                    peek.open()
                end
            end, { desc = 'Toggle Markdown Preview' })
        end,
        cmd = { 'PeekToggle' },
    },

    -- Correctly setup lspconfig for markdown.
    --
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                marksman = {},
                zk = {},
            },
        },
    },
}
