return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
        },
        config = function()
          -- get neotest namespace (api call creates or returns namespace)
          local neotest_ns = vim.api.nvim_create_namespace("neotest")
          vim.diagnostic.config({
              virtual_text = {
                  format = function(diagnostic)
                    local message =
                        diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                  end,
              },
          }, neotest_ns)


          require("neotest").setup({
              quickfix = {
                  open = false,
              },
              status = {
                  enabled = true,
                  signs = false,
                  virtual_text = true,
              },
              summary = {
                  open = "botright vsplit",
              },
              adapters = {
                  require('neotest-rust'),
                  require('neotest-go'),
              },
          })


          -- User commands
          --
          local neotest = require("neotest")
          local function keymapFn(lhs, rhs, opts)
            opts = opts or {}
            vim.keymap.set(
                opts.mode or "n",
                lhs,
                type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
                { noremap = true, silent = true, nowait = true, expr = opts.expr, desc = opts.desc }
            )
          end

          vim.api.nvim_create_user_command('GoTestProject', function()
            neotest.run.run(vim.fn.getcwd())
            neotest.summary.open()
          end, {})

          vim.api.nvim_create_user_command('GoTestPackage', function()
            neotest.run.run(vim.fn.expand("%:h"))
            neotest.summary.open()
          end, {})

          vim.api.nvim_create_user_command('GoTestFile', function()
            neotest.run.run(vim.fn.expand("%"))
            neotest.summary.open()
          end, {})

          vim.api.nvim_create_user_command('GoTestFunc', function()
            neotest.run.run()
            neotest.summary.open()
          end, {})

          keymapFn("<leader>ts", neotest.summary.toggle, { desc = "[T]est [S]ummary" })
          keymapFn("<leader>to", neotest.output.open, { desc = "[T]est [O]utput" })
          keymapFn("<leader>tO", neotest.output_panel.toggle, { desc = "[T]est [O]utput Panel" })
          keymapFn("]t", neotest.jump.next, { desc = "Next test" })
          keymapFn("[t", neotest.jump.prev, { desc = "Previous test" })
        end,
    }
}
