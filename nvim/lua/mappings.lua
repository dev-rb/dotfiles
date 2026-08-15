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

local snacks = {
  {
    "<leader>sf",
    function()
      Snacks.picker.smart()
    end,
    desc = "Smart Find Files",
  },
  {
    "<leader>fw",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>fch",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  },
  -- find
  {
    "<leader>fb",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Buffers",
  },
  {
    "<leader>fC",
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath "config" }
    end,
    desc = "Find Config File",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "Find Files",
  },
  {
    "<leader>fg",
    function()
      Snacks.picker.git_files()
    end,
    desc = "Find Git Files",
  },
  {
    "<leader>fp",
    function()
      Snacks.picker.projects()
    end,
    desc = "Projects",
  },
  {
    "<leader>fr",
    function()
      Snacks.picker.recent()
    end,
    desc = "Recent",
  },
  -- git
  {
    "<leader>gb",
    function()
      Snacks.picker.git_branches()
    end,
    desc = "Git Branches",
  },
  {
    "<leader>gl",
    function()
      Snacks.picker.git_log()
    end,
    desc = "Git Log",
  },
  {
    "<leader>gL",
    function()
      Snacks.picker.git_log_line()
    end,
    desc = "Git Log Line",
  },
  {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Git Status",
  },
  {
    "<leader>gS",
    function()
      Snacks.picker.git_stash()
    end,
    desc = "Git Stash",
  },
  {
    "<leader>gd",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Git Diff (Hunks)",
  },
  {
    "<leader>gf",
    function()
      Snacks.picker.git_log_file()
    end,
    desc = "Git Log File",
  },
  -- gh
  {
    "<leader>gi",
    function()
      Snacks.picker.gh_issue()
    end,
    desc = "GitHub Issues (open)",
  },
  {
    "<leader>gI",
    function()
      Snacks.picker.gh_issue { state = "all" }
    end,
    desc = "GitHub Issues (all)",
  },
  {
    "<leader>gp",
    function()
      Snacks.picker.gh_pr()
    end,
    desc = "GitHub Pull Requests (open)",
  },
  {
    "<leader>gP",
    function()
      Snacks.picker.gh_pr { state = "all" }
    end,
    desc = "GitHub Pull Requests (all)",
  },
  -- Grep
  {
    "<leader>sb",
    function()
      Snacks.picker.lines()
    end,
    desc = "Buffer Lines",
  },
  {
    "<leader>sB",
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = "Grep Open Buffers",
  },
  {
    "<leader>sw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "Visual selection or word",
    mode = { "n", "x" },
  },
  -- search
  {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = "Registers",
  },
  {
    "<leader>s/",
    function()
      Snacks.picker.search_history()
    end,
    desc = "Search History",
  },
  {
    "<leader>sb",
    function()
      Snacks.picker.lines()
    end,
    desc = "Buffer Lines",
  },
  {
    "<leader>sc",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  },
  {
    "<leader>sC",
    function()
      Snacks.picker.commands()
    end,
    desc = "Commands",
  },
  {
    "<leader>sd",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "Diagnostics",
  },
  {
    "<leader>sD",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "Buffer Diagnostics",
  },
  {
    "<leader>sh",
    function()
      Snacks.picker.help()
    end,
    desc = "Help Pages",
  },
  {
    "<leader>sH",
    function()
      Snacks.picker.highlights()
    end,
    desc = "Highlights",
  },
  {
    "<leader>si",
    function()
      Snacks.picker.icons()
    end,
    desc = "Icons",
  },
  {
    "<leader>sj",
    function()
      Snacks.picker.jumps()
    end,
    desc = "Jumps",
  },
  {
    "<leader>sk",
    function()
      Snacks.picker.keymaps()
    end,
    desc = "Keymaps",
  },
  {
    "<leader>sl",
    function()
      Snacks.picker.loclist()
    end,
    desc = "Location List",
  },
  {
    "<leader>sm",
    function()
      Snacks.picker.marks()
    end,
    desc = "Marks",
  },
  {
    "<leader>sM",
    function()
      Snacks.picker.man()
    end,
    desc = "Man Pages",
  },
  {
    "<leader>sq",
    function()
      Snacks.picker.qflist()
    end,
    desc = "Quickfix List",
  },
  {
    "<leader>sR",
    function()
      Snacks.picker.resume()
    end,
    desc = "Resume",
  },
  {
    "<leader>su",
    function()
      Snacks.picker.undo()
    end,
    desc = "Undo History",
  },
  -- LSP
  {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "Goto Definition",
  },
  {
    "gD",
    function()
      Snacks.picker.lsp_declarations()
    end,
    desc = "Goto Declaration",
  },
  {
    "gr",
    function()
      Snacks.picker.lsp_references()
    end,
    nowait = true,
    desc = "References",
  },
  {
    "gI",
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = "Goto Implementation",
  },
  {
    "gy",
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = "Goto T[y]pe Definition",
  },
  {
    "<leader>ls",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "LSP Symbols",
  },
  {
    "<leader>lws",
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = "LSP Workspace Symbols",
  },
}

for _, val in pairs(snacks) do
  map("n", val[1], val[2], { desc = val.desc })
end
