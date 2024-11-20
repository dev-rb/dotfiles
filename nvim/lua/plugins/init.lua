return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "echasnovski/mini.cursorword",
    lazy = false,
    version = "*",
    config = function(_, opts)
      require("mini.cursorword").setup(opts)
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function(_, opts)
      require("smart-splits").setup {
        at_edge = "stop",
        disable_multiplexer_nav_when_zoomed = false,
      }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = require "configs.nvim-tree",
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = require("configs.ufo").options,
    config = require("configs.ufo").setup,
  },

  { "akinsho/git-conflict.nvim", version = "*", config = true },

  {
    "numToStr/Comment.nvim",
    opts = require "configs.comment",
  },

  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
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

      indent = { enable = true },
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
    "nvim-telescope/telescope-ui-select.nvim",
    version = "*",
  },
  {
    "nvim-telescope/telescope.nvim",
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

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
