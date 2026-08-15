-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",

  hl_override = {
    NormalFloat = { bg = "darker_black" },
    IblScopeChar = { underline = false, link = "Visual" },
  },
  hl_add = {
    MiniCursorword = { link = "Visual", underline = false },
    SnacksPickerInput = { link = "TelescopeNormal" },
    SnacksPickerDir = { link = "TelescopeNormal" },
    SnacksPickerPreview = { link = "TelescopeNormal" },
    SnacksPickerList = { link = "TelescopeNormal" },
    SnacksPickerListTitle = { link = "TelescopePromptTitle" },
    SnacksPickerInputTitle = { link = "TelescopePromptTitle" },
    SnacksPickerInputSearch = { link = "TelescopeNormal" },
    SnacksPickerBorder = { link = "TelescopeBorder" },
    SnacksNormal = { link = "TelescopePromptTitle" },
    SnacksNormalNC = { link = "TelescopePromptTitle" },
    SnacksPickerFooter = { link = "TelescopePromptTitle" },
    SnacksPickerCol = { link = "Text" },
    SnacksPickerTitle = { link = "TelescopePromptTitle" },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  cmp = { format_colors = { tailwind = true }, icons_left = true, icons = true },
  statusline = {
    theme = "vscode_colored",
    separator_style = "round",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd" },
  },
}

M.lsp = {
  signature = true,
}

M.colorify = { highlight = { lspvars = false } }

return M
