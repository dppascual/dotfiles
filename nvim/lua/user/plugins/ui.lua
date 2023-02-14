return {

  -- Icons
  --
  {
    "nvim-tree/nvim-web-devicons",
    config = { default = true },
  },

  -- Better vim.notify
  --
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>nc",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Clear all Notifications",
      },
    },
    config = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- Floating statusline
  --
  {
    "b0o/incline.nvim",
    config = function ()
      local function get_diagnostic_label(props)
        local icons = { Error = ' ', Warn = ' ', Info = ' ', Hint = ' ' }

        local label = {}
        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
          end
        end
        return label
      end


      require('incline').setup({
        debounce_threshold = { falling = 500, rising = 250 },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ":t")
          local diagnostics = get_diagnostic_label(props)
          local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "None"
          local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

          local buffer = {
              { filetype_icon, guifg = color },
              { " " },
              { filename, gui = modified },
          }

          if #diagnostics > 0 then
              table.insert(diagnostics, { "| ", guifg = "grey" })
          end
          for _, buffer_ in ipairs(buffer) do
              table.insert(diagnostics, buffer_)
          end
          return diagnostics
        end,
      })
    end
  },

  -- Dressing for UI hooks, especially vim.ui.select
  --
  {
    'stevearc/dressing.nvim',
    config = function ()
      require('dressing').setup({
        select = {
          backend = { "fzf_lua" },
          fzf_lua = {
            winopts = {
              height = 0.33,
              width = 1,
              row = 1,
              col = 0.1,
            },
          },
        }
      })
    end
  },

  -- Animations
  --
  -- {
  --   "echasnovski/mini.animate",
  --   event = "VeryLazy",
  --   config = function()
  --     local mouse_scrolled = false
  --     for _, scroll in ipairs({ "Up", "Down" }) do
  --       local key = "<ScrollWheel" .. scroll .. ">"
  --       vim.keymap.set("", key, function()
  --         mouse_scrolled = true
  --         return key
  --       end, { expr = true })
  --     end
  --
  --     local animate = require("mini.animate")
  --
  --     animate.setup({
  --       cursor = {
  --         -- Animate for 200 milliseconds with linear easing
  --         timing = animate.gen_timing.linear({ duration = 200, unit = 'total' }),
  --
  --         -- Animate with shortest line for any cursor move
  --         path = animate.gen_path.line({
  --           predicate = function() return true end,
  --         }),
  --       },
  --       resize = {
  --         timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
  --       },
  --       scroll = {
  --         timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
  --         subscroll = animate.gen_subscroll.equal({
  --           predicate = function(total_scroll)
  --             if mouse_scrolled then
  --               mouse_scrolled = false
  --               return false
  --             end
  --             return total_scroll > 1
  --           end,
  --         }),
  --       },
  --     })
  --   end,
  -- },

  --[[
  --
  -- FURTHER RESEARCH IS REQUIRED -- plugins disabled
  --
  --]]

  -- Better quickfix window
  --
  {
    "'kevinhwang91/nvim-bqf'",
    enabled = false,
    ft = 'qf',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- Zen mode (not working as expected)
  --
  {
    "Pocco81/true-zen.nvim",
    config = function ()
      require('true-zen').setup({
        modes = { -- configurations per mode
          ataraxis = {
            shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
            backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
            minimum_writing_area = { -- minimum size of main window
              width = 70,
              height = 44,
            },
            quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
            padding = { -- padding windows
              left = 52,
              right = 52,
              top = 0,
              bottom = 0,
            },
          },
          narrow = {
            folds_style = "invisible",
            run_ataraxis = true, -- display narrowed text in a Ataraxis session
          },
        },
        integrations = {
          tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
          kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
            enabled = false,
            font = "+2"
          },
          twilight = false, -- enable twilight (ataraxis)
          lualine = true, -- hide nvim-lualine (ataraxis)
        }
      })

      -- Keymaps
      --
      vim.api.nvim_set_keymap("n", "<leader>zn", ":TZNarrow<CR>", {})
      vim.api.nvim_set_keymap("v", "<leader>zn", ":'<,'>TZNarrow<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>zf", ":TZFocus<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>zm", ":TZAtaraxis<CR>", {})

    end
  }
}
