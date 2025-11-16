require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- "basedpyright",
  "biome",
  "cssls",
  "gopls",
  "html",
  "jsonls",
  "nil_ls",
  "prettierd",
  "pylsp",
  "tailwindcss",
  "unocss",
  "vtsls",
}

-- https://github.com/yioneko/vtsls
-- npm install -g @vtsls/language-server
-- pnpm add -g @vtsls/language-server
vim.lsp.config.vtsls = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    typescript = {
      tsdk = "./node_modules/typescript/lib",
      maxTsServerMemory = 8192,
      useSeparateSyntaxServer = false,
      useSyntaxServer = "never",
      preferences = {
        importModuleSpecifier = "non-relative",
        updateImportsOnFileMove = {
          enabled = "always",
        },
        suggest = {
          completeFunctionCalls = true,
        },
      },
    },
    -- vtsls = {
    --   autoUseWorkspaceTsdk = true,
    --   experimental = {
    --     completion = {
    --       enableServerSideFuzzyMatch = true,
    --     },
    --   },
    -- },
  },
}

vim.lsp.config.tailwindcss = {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
}
--
vim.lsp.config.eslint = {
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
    experimental = {
      useFlatConfig = false,
    },
    format = false,
    nodePath = "",
    onIgnoredFiles = "off",
    problems = {
      shortenToSingleLine = false,
    },
    quiet = false,
    rulesCustomizations = {},
    run = "onSave",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location",
    },
  },
}

vim.lsp.config.unocss = {
  filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "typescript.tsx" },
  settings = {
    root_dir = function(fname)
      return require("vim.lsp.config.util").root_pattern(
        "unocss.config.js",
        "unocss.config.ts",
        "uno.config.js",
        "uno.config.ts"
      )(fname)
    end,
  },
}

vim.lsp.enable(servers)
