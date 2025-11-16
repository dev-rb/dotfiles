require "nvchad.mappings"

local map = vim.keymap.set

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

map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "K", vim.lsp.buf.hover)

map("n", "<C-w>1", "<cmd> Vr 10 <CR>")
map("n", "<C-w>2", "<cmd> Vr 20 <CR>")
map("n", "<C-w>3", "<cmd> Vr 30 <CR>")
map("n", "<C-w>4", "<cmd> Vr 40 <CR>")
map("n", "<C-w>5", "<cmd> Vr 50 <CR>")
map("n", "<C-w>6", "<cmd> Vr 60 <CR>")
map("n", "<C-w>7", "<cmd> Vr 70 <CR>")
map("n", "<C-w>8", "<cmd> Vr 80 <CR>")
map("n", "<C-w>9", "<cmd> Vr 90 <CR>")
