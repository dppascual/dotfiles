-- Statusline
--
-- return {
--
--   {
--     "nvim-lualine/lualine.nvim",
--   event = "VeryLazy",
--   enabled = false,
--     config = true,
--     },
-- }

local M = {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    enabled = false,
}

function M.config()
  -- Color table for highlights
  -- stylua: ignore
  local colors = {
    fg          = "#4d5c65",
    bg           = "#CFC1BA",
    black        = '#3c3836',
    white        = '#f9f5d7',
    orange       = '#af3a03',
    red          = "#a8334c",
    yellow       = "#82875d",
    green        = "#728a5b",
    brown        = "#958882",
    blue         = '#3387c2',
    violet       = "#88507d",
    gray         = '#d5c4a1',
    darkgray     = '#958882',
  }

    local mode_color = {
        n = colors.darkgray,
        niI = colors.darkgray,
        niR = colors.darkgray,
        niV = colors.darkgray,
        i = colors.green,
        ic = colors.green,
        ix = colors.green,
        v = colors.blue,
        vs = colors.blue,
        V = colors.blue,
        Vs = colors.blue,
        [''] = colors.blue,
        ['s'] = colors.blue,
        s = colors.blue,
        S = colors.blue,
        [''] = colors.blue,
        c = colors.bg,
        R = colors.orange,
        Rv = colors.orange,
        r = colors.red,
        rm = colors.red,
        ['r?'] = colors.red,
        ['!'] = colors.red,
        t = colors.red,
    }

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
            theme = {

                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } },
            },
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
        color = function()
            -- auto change color according to neovims mode
            return {
                fg = colors.white,
                bg = mode_color[vim.fn.mode()],
                gui = 'bold',
            }
        end,
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
        path = 0,
        file_status = true,
        symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
        },
        color = { fg = colors.fg },
    })

    ins_left({
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = {
            error = ' ',
            warn = ' ',
            info = ' ',
            hint = ' ',
        },
        diagnostics_color = {
            error = { fg = colors.red, bg = colors.bg },
            warn = { fg = colors.yellow, bg = colors.bg },
            info = { fg = colors.blue, bg = colors.bg },
            hint = { fg = colors.violet, bg = colors.bg },
        },
    })

    -- Add components to right sections
    ins_right({
        -- Lsp server name .
        function()
            local msg = {}
            -- local msg = {'No Active Lsp'}
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
                return 'No active Lsp'
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    table.insert(msg, client.name)
                end
            end
            print(vim.inspect(msg))
            return table.concat(msg, '|')
        end,
        icon = ' ',
        color = { fg = colors.fg },
    })

    ins_right({
        'o:encoding', -- option component same as &encoding in viml
        cond = conditions.hide_in_width,
        color = { fg = colors.fg },
    })

    ins_right({
        'fileformat',
        icons_enabled = false,
        color = { fg = colors.fg },
    })

    ins_right({
        'filetype',
        cond = conditions.buffer_not_empty,
        colored = false,
        icon_only = false,
        color = { fg = colors.fg },
        -- padding = { left = 1, right = 0 },
    })

    ins_right({
        'branch',
        icon = '',
        color = { fg = colors.fg },
    })

    ins_right({
        'diff',
        symbols = { added = ' ', modified = '柳 ', removed = ' ' },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
    })

    ins_right({
        'progress',
        color = function()
            -- auto change color according to neovims mode
            return {
                fg = colors.white,
                bg = mode_color[vim.fn.mode()],
                gui = 'bold',
            }
        end,
        separator = { left = '' },
    })

    ins_right({
        'location',
        color = function()
            -- auto change color according to neovims mode
            return {
                fg = colors.white,
                bg = mode_color[vim.fn.mode()],
                gui = 'bold',
            }
        end,
        padding = { right = 1 },
    })

    -- Now don't forget to initialize lualine
    require('lualine').setup(config)
end

return M
