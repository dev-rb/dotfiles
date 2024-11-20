-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",

  hl_override = {
    IblScopeChar = { underline = false, link = "Visual" },
  },
  hl_add = {
    ["IlluminatedWordText"] = { link = "Visual", underline = false },
    ["IlluminatedWordRead"] = { link = "Visual", underline = false },
    ["IlluminatedWordWrite"] = { link = "Visual", underline = false },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  cmp = { format_colors = { tailwind = true }, icons_left = true, icons = true },
  statusline = { theme = "minimal" },
}

M.lsp = {
  signature = true,
}

M.colorify = { highlight = { lspvars = false } }

return M
