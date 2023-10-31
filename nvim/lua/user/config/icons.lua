local M = {}

--- Diagnostic severities.
M.diagnostics = {
    ERROR = 'E',
    WARN = 'W',
    HINT = 'H',
    INFO = 'I',
}

--- For folding.
M.arrows = {
    right = '',
    left = '',
    up = '',
    down = '',
}

--- LSP symbol kinds.
M.symbol_kinds = {
    Method = ' ',
    Function = ' ',
    Constructor = ' ',
    Variable = ' ',
    Field = ' ',
    TypeParameter = ' ',
    Constant = ' ',
    Class = ' ',
    Interface = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    Module = ' ',
    Property = ' ',
    Value = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Reference = ' ',
    Keyword = ' ',
    File = ' ',
    Folder = '󰉋 ',
    Color = ' ',
    Unit = ' ',
    Snippet = ' ',
    Text = ' ',
}

--- Shared icons that don't really fit into a category.
M.misc = {
    bug = '',
    git = '',
    search = '',
    vertical_bar = '│',
}

return M
