-- Servers with their settings
---@type lspconfig.options
local servers = {
    bashls = {},
    dockerls = {},
    jsonls = {
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                format = {
                    enable = true,
                },
                validate = {
                    enable = true
                },
            },
        },
    },
    bufls = {},
    gopls = {
        gopls = {
            -- buildFlags = { "-tags=debug" },
            analyses = {
                unusedparams = true,
                hover = true,
            },
            staticcheck = true,
            experimentalPostfixCompletions = true,
            codelenses = { test = true },
            hints = {
                parameterNames = true,
                assignVariableTypes = true,
                constantValues = true,
                rangeVariableTypes = true,
                compositeLiteralTypes = true,
                compositeLiteralFields = true,
                functionTypeParameters = true,
            },
        },
    },
    -- rust-analyzer is installed manually by rustup,
    -- that way we have the very same version of rust and
    -- its language server protocol.
    -- rust_analyzer = {},
    yamlls = {
        yaml = {
            schemaStore = {
                url = "https://www.schemastore.org/api/json/catalog.json",
                enable = true,
            },
        },
    },
    lua_ls = {
        -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
        single_file_support = true,
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                completion = {
                    workspaceWord = true,
                    callSnippet = "Both",
                },
                misc = {
                    parameters = {
                        "--log-level=trace",
                    },
                },
                diagnostics = {
                    -- enable = false,
                    groupSeverity = {
                        strong = "Warning",
                        strict = "Warning",
                    },
                    groupFileStatus = {
                        ["ambiguity"] = "Opened",
                        ["await"] = "Opened",
                        ["codestyle"] = "None",
                        ["duplicate"] = "Opened",
                        ["global"] = "Opened",
                        ["luadoc"] = "Opened",
                        ["redefined"] = "Opened",
                        ["strict"] = "Opened",
                        ["strong"] = "Opened",
                        ["type-check"] = "Opened",
                        ["unbalanced"] = "Opened",
                        ["unused"] = "Opened",
                    },
                    unusedLocalExclude = { "_*" },
                },
                format = {
                    enable = false,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "2",
                        continuation_indent_size = "2",
                    },
                },
            },
        },
    },
}

return servers
