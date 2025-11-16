return {
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
    dependencies = { "saghen/blink.cmp" },
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = require("configs.conform").setup,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    config = function()
      require("smart-splits").setup {
        at_edge = "stop",
        disable_multiplexer_nav_when_zoomed = false,
      }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    opts = require "configs.nvim-tree",
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = require("configs.ufo").options,
    config = require("configs.ufo").setup,
  },

  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    opts = require "configs.comment",
  },

  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "VeryLazy",
        config = function()
          require("ts_context_commentstring").setup {}
        end,
      },
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "css",
        "html",
        "javascript",
        "lua",
        "python",
        "scss",
        "tsx",
        "typescript",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      scope = { enabled = false },
    },
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    version = "*",
    enabled = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = function(_, conf)
      conf.extensions_list = { "themes", "terms", "ui-select" }

      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_cursor {},
            specific_opts = {
              codeactions = true,
            },
          },
        },
      }
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "nvim-mini/mini.cursorword",
    event = "VeryLazy",
    version = false,
    opts = {},
  },
  { "nvim-mini/mini.ai", event = "VeryLazy", version = false, opts = { search_method = "cover_or_nearest" } },
  { "nvim-mini/mini.move", event = "VeryLazy", version = false, opts = {} },
  {
    "folke/snacks.nvim",
    priority = 1000,
    event = "VeryLazy",
    config = function()
      require "configs.snacks"
    end,
  },
}
