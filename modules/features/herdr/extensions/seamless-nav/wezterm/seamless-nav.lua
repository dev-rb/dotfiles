-- seamless-nav: forward Ctrl+h/j/k/l from WezTerm into herdr.
-- Loading this file does not change any key bindings; call `forward` from
-- your own navigation callback (see README.md).
local wezterm = require("wezterm")

local codepoints = { h = 104, j = 106, k = 107, l = 108 }

local M = {}

function M.is_herdr(pane)
	local name = pane:get_foreground_process_name() or ""
	return name == "herdr" or name:match("[/\\]herdr$") ~= nil
end

-- Returns true when the key was forwarded into a herdr client.
function M.forward(window, pane, key)
	local codepoint = codepoints[key]
	if not codepoint or not M.is_herdr(pane) then
		return false
	end
	-- Explicit CSI-u keeps Ctrl+H/J distinct from Backspace/Enter.
	window:perform_action(wezterm.action.SendString(string.format("\x1b[%d;5u", codepoint)), pane)
	return true
end

return M
