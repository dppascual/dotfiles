local M = {
  "L3MON4D3/LuaSnip",
  build = 'make install_jsregexp',
  dependencies = {
    'hrsh7th/nvim-cmp',
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}

function M.config()
  local present, luasnip = pcall(require, "luasnip")
  if not present then
    return
  end

  luasnip.config.set_config {
    history = true,
    updateevents = "InsertLeave,TextChanged,TextChangedI",
    enable_autosnippets = false,
  }
end

return M
