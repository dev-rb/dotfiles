-- https://github.com/NvChad/ui/blob/v2.5/lua/nvchad/lsp/init.lua
local M = {}

M.diagnostic_config = function()
	local x = vim.diagnostic.severity

	vim.diagnostic.config({
		virtual_text = { prefix = "" },
		signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
		underline = true,
		float = { border = "single" },
	})
end

return M
