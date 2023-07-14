-- Servers with their settings
---@type lspconfig.options
local servers = {
    gopls = {
    },
    -- rust-analyzer is installed manually by rustup,
    -- that way we have the very same version of rust and
    -- its language server protocol.
    -- rust_analyzer = {},
    taplo = {},
}

return servers
