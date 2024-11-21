local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    nix = { "nixfmt" },
    javascript = {
      "prettierd",
      "biome",
      stop_after_first = true
    },
    javascriptreact = {
      "prettierd",
      "biome",
      stop_after_first = true
    },
    typescript = {
      "prettierd",
      "biome",
      stop_after_first = true
    },
    typescriptreact = {
      "prettierd",
      "biome",
      stop_after_first = true
    },
  },

  format_after_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2500,
    lsp_fallback = true,
  },
}

return options
