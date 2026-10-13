return {
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
    dependencies = { "saghen/blink.cmp" },
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
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
        -- Inside herdr, continue to herdr's sidebar or the neighboring WezTerm pane
        -- at the outer edge; stop when the Herdr feature is not deployed.
        at_edge = (function()
          local root = vim.env.HERDR_SEAMLESS_NAV_DIR
            or (vim.fn.fnamemodify(vim.fn.stdpath "config", ":h") .. "/herdr/extensions/seamless-nav")
          local path = root .. "/nvim/at_edge.lua"
          return vim.fn.filereadable(path) == 1 and dofile(path) or "stop"
        end)(),
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
    lazy = false,
    event = "BufRead",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {
        install_dir = vim.fn.stdpath "data" .. "/site",
      }

      local parsers = {
        "bash",
        "css",
        "diff",
        "editorconfig",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      }

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          require("nvim-treesitter").install(parsers)
        end,
      })
    end,
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
  -- { "nvim-mini/mini.ai", event = "VeryLazy", version = false, opts = { search_method = "cover_or_nearest" } },
  { "nvim-mini/mini.move", event = "VeryLazy", version = false, opts = {} },
  {
    "folke/snacks.nvim",
    priority = 1000,
    event = "VeryLazy",
    opts = require "configs.snacks",
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      disable_filetype = { "snacks_picker_input" },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode…" })

      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })

      vim.keymap.set({ "n", "t" }, "<C-.>", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function()
        return require("opencode").operator "@this "
      end, { desc = "Add range to opencode", expr = true })

      vim.keymap.set("n", "goo", function()
        return require("opencode").operator "@this " .. "_"
      end, { desc = "Add line to opencode", expr = true })

      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command "session.half.page.up"
      end, { desc = "Scroll opencode up" })

      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command "session.half.page.down"
      end, { desc = "Scroll opencode down" })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
  },
}
