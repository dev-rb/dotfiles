require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
vim.keymap.del("n", "<Tab>")
vim.keymap.del("n", "<S-Tab>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n", "i", "v" }, "<C-c>", "<ESC>")

map({ "n", "x" }, "k", "gk")
map({ "n", "x" }, "j", "gj")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>cf", "<cmd> foldclose <CR>")
map("n", "<leader>of", "<cmd> foldopen <CR>")

map("n", "tt", function()
  require("base46").toggle_transparency()
end)

map("n", "<C-h>", function()
  require("smart-splits").move_cursor_left()
end)

map("n", "<C-j>", function()
  require("smart-splits").move_cursor_down()
end)

map("n", "<C-k>", function()
  require("smart-splits").move_cursor_up()
end)

map("n", "<C-l>", function()
  require("smart-splits").move_cursor_right()
end)

map("n", "<leader>lr", "<cmd> LspRestart <CR>")

map("n", "<leader>f", function()
  vim.diagnostic.open_float { border = "rounded" }
end)
