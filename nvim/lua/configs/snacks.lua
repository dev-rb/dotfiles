local options = {
  quickfile = { enabled = true },
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
