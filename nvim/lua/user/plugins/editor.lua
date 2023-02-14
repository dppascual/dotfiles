return {

    -- file explorer
    -- {
    --   "nvim-neo-tree/neo-tree.nvim",
    --   cmd = "Neotree",
    --   dependencies = {
    --     "nvim-lua/plenary.nvim",
    --     "nvim-tree/nvim-web-devicons",
    --     "MunifTanjim/nui.nvim",
    --   },
    --   keys = {
    --     {
    --       "<leader>fe",
    --       function()
    --         require("neo-tree.command").execute({ toggle = true, dir = require("user.util").get_root() })
    --       end,
    --       desc = "Explorer NeoTree (root dir)",
    --     },
    --     { "<leader>fE", "<cmd>Neotree toggle<CR>", desc = "Explorer NeoTree (cwd)" },
    --     { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    --     { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    --   },
    --   init = function()
    --     vim.g.neo_tree_remove_legacy_commands = 1
    --     if vim.fn.argc() == 1 then
    --       local stat = vim.loop.fs_stat(vim.fn.argv(0))
    --       if stat and stat.type == "directory" then
    --         require("neo-tree")
    --       end
    --     end
    --   end,
    --   opts = {
    --     filesystem = {
    --       follow_current_file = true,
    --     },
    --   },
    -- },

    -- Fuzzy Finder with fzf
    --
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
          local actions = require 'fzf-lua.actions'
          require('fzf-lua').setup({
              winopts = {
                  height = 0.33,
                  width = 1,
                  row = 1,
                  col = 0,
                  preview = {
                      default = 'bat',
                      wrap = 'wrap',
                      hidden = 'nohidden',
                      layout = 'flex',
                      horizontal = 'right:70%'
                  },
              },
              keymap = {
                  builtin = {
                      ["<C-->"] = "toggle-fullscreen",
                      ["<C-p>"] = "toggle-preview",
                      ["<C-u>"] = "preview-page-up",
                      ["<C-d>"] = "preview-page-down",
                  },
                  fzf = {
                      ["ctrl-a"] = "beginning-of-line",
                      ["ctrl-e"] = "end-of-line",
                      ["ctrl-p"] = "toggle-preview",
                      ["alt-k"] = "preview-up",
                      ["alt-j"] = "preview-down",
                      ["ctrl-u"] = "preview-half-page-up",
                      ["ctrl-d"] = "preview-half-page-down",
                  },
              },
              actions = {
                  files = {
                      -- providers that inherit these actions:
                      --   files, git_files, git_status, grep, lsp
                      --   oldfiles, quickfix, loclist, tags, btags
                      --   args
                      -- default action opens a single selection
                      -- or sends multiple selection to quickfix
                      -- replace the default action with the below
                      -- to open all files whether single or multiple
                      ["default"] = actions.file_edit,
                      ["ctrl-s"] = actions.file_split,
                      -- ["ctrl-v"] = actions.file_vsplit,
                      ["ctrl-v"] = function(selected, opts)
                        local file = require 'fzf-lua'.path.entry_to_file(selected[1], opts)
                        local cmd = string.format(":rightbelow vnew %s", file.path)
                        vim.cmd(cmd)
                      end,
                      -- copy selected entries to register
                      ["ctrl-y"] = function(selected, opts)
                        vim.fn.setreg('+', selected)
                      end,
                      ["alt-q"] = actions.file_sel_to_qf,
                  },
                  buffers = {
                      -- providers that inherit these actions:
                      --   buffers, tabs, lines, blines
                      ["default"] = actions.buf_edit,
                      ["ctrl-s"]  = actions.buf_split,
                      ["ctrl-v"]  = actions.buf_vsplit,
                  },
              },
              previewers = {
                  git_diff = {
                      pager = "delta --width=$FZF_PREVIEW_COLUMNS",
                  },
              },
              files = {
                  prompt = 'Files❯ ',
              },
              -- fzf_colors = {
              --          ["fg"]          = { "fg", "CursorLine" },
              --          ["bg"]          = { "bg", "Normal" },
              --          ["hl"]          = { "fg", "Comment" },
              --          ["fg+"]         = { "fg", "Normal" },
              --          ["bg+"]         = { "bg", "PmenuSel" },
              --          ["hl+"]         = { "fg", "Statement" },
              --          ["info"]        = { "fg", "PreProc" },
              --          ["prompt"]      = { "fg", "Conditional" },
              --          ["pointer"]     = { "fg", "Exception" },
              --          ["marker"]      = { "fg", "Keyword" },
              --          ["spinner"]     = { "fg", "Label" },
              --          ["header"]      = { "fg", "Comment" },
              --          ["gutter"]      = { "bg", "Normal" },
              --        },
          })

          local function keymapFn(lhs, rhs, opts)
            opts = opts or {}
            vim.keymap.set(
                opts.mode or "n",
                lhs,
                type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
                { noremap = true, silent = true, expr = opts.expr, desc = opts.desc }
            )
          end

          -- Keymaps
          keymapFn('<leader>?', "lua require('fzf-lua').builtin({ winopts = { height =0.33, width = 1 }})",
              { desc = '[?] Built-in' })
          keymapFn('<leader>:', require('fzf-lua').commands, { desc = '[?] User Commands' })

          -- Files
          --
          keymapFn('<leader>/', require('fzf-lua').blines, { desc = '[/] Fuzzily search in current buffer' })
          keymapFn('<leader>sb', "lua require('fzf-lua').blines({ winopts = { preview = { horizontal = 'right:60%' }}})",
              { desc = 'Fuzzily [S]earch in current [B]uffer' })
          keymapFn('<leader>sB', "lua require('fzf-lua').lines({ winopts = { preview = { horizontal = 'right:60%' }}})",
              { desc = 'Fuzzily search in all opened buffers' })
          keymapFn('<leader>,', require('fzf-lua').buffers, { desc = '[,] Search Buffers' })
          keymapFn('<leader>ff', require('fzf-lua').files, { desc = '[F]ind [F]iles' })
          keymapFn('<leader>sf',
              "lua require('fzf-lua').live_grep({ winopts = { preview = { horizontal = 'right:60%' }}})",
              { desc = '[S]earch in [F]iles' })
          -- keymapFn('<leader>sF', "<cmd>lua require('fzf-lua').files({ cwd='~/<folder>' })<CR>", { noremap = true, silent = true, desc = '[S]earch [F]iles in Current Working Directory' })

          -- Grep
          --
          keymapFn('<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch current [W]ord' })
          keymapFn('<leader>sW', require('fzf-lua').grep_cWORD, { desc = '[S]earch current uppercase [W]ord' })
          keymapFn('<leader>sw', require('fzf-lua').grep_visual, { mode = "v", desc = '[S]earch current visual [Word]' })

          -- Git
          --
          keymapFn('<leader>gf', require('fzf-lua').git_files, { desc = '[G]it [F]iles' })
          keymapFn('<leader>gs',
              "lua require('fzf-lua').git_status({ winopts = { height = 1, width = 1, preview = { horizontal = 'right:85%' }}})",
              { desc = '[G]it [S]tatus' })
          keymapFn('<leader>gc', "lua require('fzf-lua').git_commits({ winopts = { height = 1, width = 1 }})",
              { desc = '[G]it [C]ommits' })
          keymapFn('<leader>bc', "lua require('fzf-lua').git_bcommits({ winopts = { height = 1, width = 1 }})",
              { desc = '[Buffer] [C]ommits' })
          keymapFn('<leader>gb', require('fzf-lua').git_branches, { desc = '[G]it [B]ranches' })

          -- Diagnostic
          --
          keymapFn('<leader>xl', vim.diagnostic.open_float, { desc = '[X] Diagnostics [L]ist' })
          keymapFn('<leader>xd', require('fzf-lua').diagnostics_document, { desc = '[X] Diagnostics [D]ocument' })
          keymapFn('<leader>xw', require('fzf-lua').diagnostics_workspace, { desc = '[X] Diagnostics [W]orkspace' })
        end,
    },

    -- Fuzzy Finder with Telescope (it's used when no found an implementation over fzf)
    --
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.1',
        config = true,
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- Move a line or a selection
    --
    {
        "echasnovski/mini.move",
        config = function()
          require('mini.move').setup()
        end
    },

    -- Autopairs
    --
    {
        "echasnovski/mini.pairs",
        config = function()
          require('mini.pairs').setup()
        end
    },

    -- Git functionality
    --
    {
        'lewis6991/gitsigns.nvim',
        config = function()
          require('gitsigns').setup({
              signs = {
                  add          = { text = '│' },
                  change       = { text = '│' },
                  delete       = { text = '│' },
                  topdelete    = { text = '‾' },
                  changedelete = { text = '~' },
                  untracked    = { text = '│' },
              },
              numhl = true,
              current_line_blame_opts = {
                  virt_text_pos = 'right_align',
              },
              preview_config = {
                  border = 'rounded',
              },
              on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                  opts = opts or {}
                  opts.buffer = bufnr
                  vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                  if vim.wo.diff then return ']c' end
                  vim.schedule(function() gs.next_hunk() end)
                  return '<Ignore>'
                end, { expr = true })

                map('n', '[c', function()
                  if vim.wo.diff then return '[c' end
                  vim.schedule(function() gs.prev_hunk() end)
                  return '<Ignore>'
                end, { expr = true })

                -- Actions
                map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
                map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
                map('n', '<leader>hS', gs.stage_buffer)
                map('n', '<leader>hu', gs.undo_stage_hunk)
                map('n', '<leader>hR', gs.reset_buffer)
                map('n', '<leader>hp', gs.preview_hunk)
                map('n', '<leader>hb', function() gs.blame_line { full = true } end)
                map('n', '<leader>tb', gs.toggle_current_line_blame)
                map('n', '<leader>hd', gs.diffthis)
                map('n', '<leader>hD', function() gs.diffthis('~') end)
                map('n', '<leader>td', gs.toggle_deleted)

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
              end
          })
        end,
    },
    -- better diffing
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
        keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },

    -- Better yank and put funcionalities for Neovim
    --
    {
        "gbprod/yanky.nvim",
        event = "BufReadPost",
        config = function()
          require('yanky').setup()

          vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")

          vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
          vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
          vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
          vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

          vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
          vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

          vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
          vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
          vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
          vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

          vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
          vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
          vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
          vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

          vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
          vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

          vim.keymap.set("n", "<leader>p", "<cmd>:YankyRingHistory<CR>", { desc = "Paste from Yanky" })
        end,
    },

    --[[
  --
  -- FURTHER RESEARCH IS REQUIRED -- plugins disabled
  --
  --]]

    -- Easily jump to any location and enhanced f/t motions for Leap
    {
        "ggandor/leap.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
            { "ggandor/flit.nvim", config = { labeled_modes = "nv" } },
        },
        config = function()
          require("leap").add_default_mappings()
        end,
    },

    -- References
    --
    {
        "RRethy/vim-illuminate",
        enabled = false,
        event = "BufReadPost",
        config = function()
          require("illuminate").configure({ delay = 200 })
        end,
        keys = {
            {
                "]]",
                function()
                  require("illuminate").goto_next_reference(false)
                end,
                desc = "Next Reference",
            },
            {
                "[[",
                function()
                  require("illuminate").goto_prev_reference(false)
                end,
                desc = "Previous Reference",
            },
        },
    },

    {
        "Wansmer/treesj",
        enabled = false,
        keys = {
            { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
        },
        opts = { use_default_keymaps = false, max_join_length = 150 },
    },

    -- Structural search and replace
    --
    {
        "cshuaimin/ssr.nvim",
        enabled = false,
        keys = {
            {
                "<leader>sR",
                function()
                  require("ssr").open()
                end,
                mode = { "n", "x" },
                desc = "Structural Replace",
            },
        },
    },

    -- Better motion for the vim's % key
    {
        "andymass/vim-matchup",
        enabled = false,
        event = "BufReadPost",
        config = function()
          vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },

}
