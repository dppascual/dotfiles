local M = {
  "feline-nvim/feline.nvim",
  event = "VeryLazy",
  enabled = false,
}

function M.config()
 local ok, feline = pcall(require, "feline")
  if not ok then
          return
  end

  local zenbones = {
          fg = "#2c363c",
          lfg = "#4d5c65",
          bg = "#CFC1BA",
          white = "#e8e4e3",
          green = "#819B69",
          red = "#a8334c",
          yellow = "#959b69",
          purple = "#88507d",
          orange = "#A87D33",
          blue = "#c0d1de",
          brown = "#958882",
          aqua = "#286486",
          darkblue = "#286486",
          dark_red = "#A8334C",
  }

  local default_theme = zenbones

  local vi_mode_colors = {
          NORMAL = default_theme.brown,
          OP = default_theme.green,
          INSERT = default_theme.green,
          VISUAL = default_theme.blue,
          LINES = default_theme.blue,
          BLOCK = default_theme.dark_red,
          REPLACE = default_theme.red,
          COMMAND = default_theme.aqua,
  }

  local component = {}


  component.vim_mode = {
    provider = function()
      return require("feline.providers.vi_mode").get_vim_mode()
    end,
    hl = function()
      return {
        bg = require("feline.providers.vi_mode").get_mode_color(),
        style = "bold",
      }
    end,
    left_sep = "block",
    right_sep = "right_rounded",
  }

  component.file_size = {
    provider = "file_size",
    hl = {
      fg = "lfg",
    },
    left_sep = "block",
    right_sep = "block",
  }

  component.fileinfo = {
    provider = {
      name = "file_info",
      opts = {
        colored_icon = false,
        file_modified_icon = "[+]",
        type = "unique",
      },
    },
    hl = {
      fg = "lfg",
    },
    left_sep = "block",
    right_sep = "block",
  }


  component.diagnostic_errors = {
    provider = "diagnostic_errors",
    hl = {
      fg = "red",
    },
    left_sep = "block",
    right_sep = "block",
    icon = ' '
  }

  component.diagnostic_warnings = {
    provider = "diagnostic_warnings",
    hl = {
      fg = "yellow",
    },
    left_sep = "block",
    right_sep = "block",
    icon = ' '
  }

  component.diagnostic_info = {
    provider = "diagnostic_info",
    hl = {
      fg = "aqua",
    },
    left_sep = "block",
    right_sep = "block",
    icon = ' '
  }

  component.diagnostic_hints = {
    provider = "diagnostic_hints",
    hl = {
      fg = "purple",
    },
    left_sep = "block",
    right_sep = "block",
    icon = ' '
  }

  component.lsp_client_names = {
    provider = "lsp_client_names",
    hl = {
      fg = "lfg",
    },
    icon = '  ',
    left_sep = "block",
    right_sep = "block",
  }

  component.file_encoding = {
    provider = function ()
      return string.format("%s", vim.bo.fileencoding)
    end,
    hl = {
      fg = "lfg",
    },
    left_sep = "block",
    right_sep = "block",
  }

  component.file_format = {
    provider = function ()
      return string.format("%s", vim.bo.fileformat)
    end,
    hl = {
      fg = "lfg",
    },
    left_sep = "block",
    right_sep = "block",
  }


  component.gitBranch = {
    provider = "git_branch",
    hl = {
      fg = "lfg",
    },
    left_sep = "block",
    right_sep = "block",
  }

  component.gitDiffAdded = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
    },
    icon = ' ',
    left_sep = "block",
    right_sep = "block",
  }

  component.gitDiffRemoved = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
    },
    icon = ' ',
    left_sep = "block",
    right_sep = "block",
  }

  component.gitDiffChanged = {
    provider = "git_diff_changed",
    hl = {
      fg = "orange",
    },
    icon = '柳',
    left_sep = "block",
    right_sep = "right_filled",
  }

  component.line_percentage = {
    provider = "line_percentage",
    hl = function ()
      return {
        fg = "fg",
        bg = require("feline.providers.vi_mode").get_mode_color(),
      }
    end,
    left_sep = "left_rounded",
    right_sep = "block",
  }

  component.position = {
    provider = "position",
    hl = function ()
      return {
        fg = "fg",
        bg = require("feline.providers.vi_mode").get_mode_color(),
      }
    end,
    left_sep = "block",
    right_sep = "block",
  }


  local left = {
    component.vim_mode,
    component.file_size,
    component.fileinfo,
    component.diagnostic_errors,
    component.diagnostic_warnings,
    component.diagnostic_info,
    component.diagnostic_hints,
  }

  local right = {
    component.lsp_client_names,
    component.file_encoding,
    component.file_format,
    component.gitBranch,
    component.gitDiffAdded,
    component.gitDiffRemoved,
    component.gitDiffChanged,
    component.line_percentage,
    component.position,
  }

  local components = {
          active = {
                  left,
                  right,
          },
          inactive = {
                  left,
                  right,
          },
  }

  feline.setup({
          components = components,
          theme = default_theme,
          vi_mode_colors = vi_mode_colors,
  })
end

return M
