return {

  -- Detect tabstop and shiftwidth automatically
  --
  "tpope/vim-sleuth",

  -- TODO Comments
  --
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
  },

  -- Comment with TreeSitter
  --
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Surround with TreeSitter
  --
  {
    'kylechui/nvim-surround',
    config = function ()
      require('nvim-surround').setup()
    end
  },
}
