-- Statusline
--

local M = {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    enabled = true,
}

function M.config()
    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,

        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,

        check_git_workspace = function()
            local filepath = vim.fn.expand('%:p:h')
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    -- Config
    local config = {
        options = {
            -- Disable sections and component separators
            component_separators = '',
            section_separators = '',
            theme = 'auto',
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            -- normal = { c = { fg="#24292e", bg="#2188ff" } },
            -- inactive = { c = {  fg="#24292e", bg="#2188ff" } },
            --   normal = { c = { fg="#d4d4d4", bg="#004b72" } },
            --   inactive = { c = {  fg="#d4d4d4", bg="#004b72" } },
            -- },
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            -- These will be filled later
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    ins_left({
        'mode',
        separator = { right = '' },
        padding = { left = 1, right = 1 },
    })

    ins_left({
        'filesize',
        cond = conditions.buffer_not_empty,
    })

    ins_left({
        'filename',
        cond = conditions.buffer_not_empty,
        path = 1,
        file_status = true,
        symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
        },
    })

    ins_left({
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = '󰌵 ',
        },
    })

    ins_left({
        'macro-recording',
        fmt = function()
            local recording_register = vim.fn.reg_recording()
            if recording_register == '' then
                return ''
            else
                return 'Recording @' .. recording_register
            end
        end,
    })

    -- Add components to right sections
    ins_right({
        -- Lsp server name .
        function()
            local msg = {}
            local bufnr = vim.api.nvim_get_current_buf()
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients({
                bufnr = bufnr,
            })
            if next(clients) == nil then
                return 'No active Lsp'
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    table.insert(msg, client.name)
                end
            end
            return string.format('( %s )', table.concat(msg, ' | '))
        end,
        icon = ' ',
    })

    ins_right({
        'o:encoding', -- option component same as &encoding in viml
        cond = conditions.hide_in_width,
    })

    ins_right({
        'fileformat',
        icons_enabled = false,
    })

    ins_right({
        'filetype',
        cond = conditions.buffer_not_empty,
        colored = false,
        icon_only = false,
        -- padding = { left = 1, right = 0 },
    })

    ins_right({
        'branch',
        icon = '',
    })

    ins_right({
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
        cond = conditions.hide_in_width,
    })

    ins_right({
        'progress',
        separator = { left = '' },
    })

    ins_right({
        'location',
        padding = { right = 1 },
    })

    -- Now don't forget to initialize lualine
    require('lualine').setup(config)
end

return M
