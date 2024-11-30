-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- https://github.com/yioneko/vtsls
-- npm install -g @vtsls/language-server
-- pnpm add -g @vtsls/language-server
lspconfig.vtsls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.tailwindcss.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.eslint.setup {
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  on_attach = nvlsp.on_attach,
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

lspconfig.unocss.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "typescript.tsx" },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(
      "unocss.config.js",
      "unocss.config.ts",
      "uno.config.js",
      "uno.config.ts"
    )(fname)
  end,
}
