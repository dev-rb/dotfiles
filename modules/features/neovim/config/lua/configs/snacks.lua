local responsive_width = require "configs.responsive-width"

local options = {
  quickfile = { enabled = true },
  terminal = {
    win = {
      width = function()
        return responsive_width.get(vim.o.columns)
      end,
    },
  },
  picker = {
    win = {
      input = {
        keys = {
          ["<c-l>"] = { "focus_preview", mode = { "i", "n" } },
        },
        b = {
          minimove_disable = true,
        },
      },
      preview = {
        keys = {
          ["<c-h>"] = { "focus_input", mode = { "i", "n" } },
        },
      },
    },
  },
  zen = {},
}

return options
