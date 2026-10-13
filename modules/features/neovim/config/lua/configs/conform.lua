local M = {}

local formatter_data = {
  prettier = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
  },
  eslint = {
    ".eslintrc",
    ".eslintrc.json",
    "eslint.config.mjs",
  },
  ["biome-check"] = {
    "biome.json",
    "biome.jsonc",
  },
  biome = {
    "biome.json",
    "biome.jsonc",
  },
}

-- https://github.com/asilvadesigns/config/blob/master/nvim/lua/config/plugins/conform.lua
local function find_closest_config_file(config_names, current_file)
  if config_names == nil then
    return nil
  end
  for _, config_name in ipairs(config_names) do
    local found = vim.fs.find(config_name, { upward = true, path = vim.fn.fnamemodify(current_file, ":p:h") })
    if #found > 0 then
      return found[1] -- Return the closest config file found
    end
  end
  return nil -- No config file found
end

M.setup = function()
  local options = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
      nix = { "nixfmt" },
      javascript = {
        "prettierd",
        "biome",
        stop_after_first = true,
      },
      javascriptreact = {
        "prettierd",
        "biome",
        stop_after_first = true,
      },
      typescript = {
        "prettierd",
        "biome",
        stop_after_first = true,
      },
      typescriptreact = {
        "prettierd",
        "biome",
        stop_after_first = true,
      },
    },

    formatters = {
      prettier = {
        require_cwd = true,
      },
      prettierd = {
        require_cwd = true,
      },
      biome = {
        require_cwd = true,
      },
    },

    format_after_save = function()
      local conform = require "conform"
      local formatters = conform.list_formatters(0)
      local current_file = vim.api.nvim_buf_get_name(0)

      if #formatters == 0 then
        -- vim.print("Formatted with lsp", vim.log.levels.WARN)
        return { lsp_format = "fallback", timeout_ms = 8000 }
      end

      local formatter_to_use = nil
      for _, formatter in ipairs(formatters) do
        local config_file = find_closest_config_file(formatter_data[formatter.name], current_file)
        if config_file then
          formatter_to_use = formatter.name
          break
        end
      end

      if not formatter_to_use then
        formatter_to_use = formatters[1].name -- Fallback to the first available formatter
      end

      -- vim.print("Formatted with " .. formatter_to_use, vim.log.levels.INFO)
      return { lsp_format = "never", formatters = { formatter_to_use } }
    end,
  }

  require("conform").setup(options)
end

return M
