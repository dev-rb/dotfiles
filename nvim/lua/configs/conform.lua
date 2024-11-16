local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    nix = { "nixfmt" },
    javascript = {
      "biome",
      "prettierd",
    },
    javascriptreact = {
      "biome",
      "prettierd",
    },
    typescript = {
      "biome",
      "prettierd",
    },
    typescriptreact = {
      "biome",
      "prettierd",
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
