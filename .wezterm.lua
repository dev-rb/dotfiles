-- -- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.scrollback_lines = 3500
-- For example, changing the color scheme:
config.color_scheme = "Argonaut (Gogh)"
-- config.default_gui_startup_args = { 'connect', 'unix' }
-- config.default_prog = { 'wsl' }
-- config.unix_domains = {
--     {
--       name = "wsl",
--       connect_automatically = true,
--       serve_command = {"wsl", "wezterm-mux-server", "--daemonize"},
--     }
--   }
-- config.enable_wayland = false
wezterm.log_error("System " .. wezterm.target_triple .. " " .. tostring(wezterm.running_under_wsl()))
config.window_padding = {
	top = 0,
	left = 0,
	bottom = 0,
	right = 0,
}


config.default_domain = 'WSL:Ubuntu'
config.window_background_image = 'D:/Desktop/Pictures/wallhaven-q6532q.png'
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.2,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	hue = 1.0,

	-- You can adjust the saturation also.
	saturation = 1.0,
}
config.window_background_opacity = 1
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.adjust_window_size_when_changing_font_size = false
-- config.win32_system_backdrop = "Acrylic"
config.front_end = "OpenGL"
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
local window_min = " - "
local window_max = " + "
local window_close = " x "
config.tab_bar_style = {
	window_hide = window_min,
	window_hide_hover = window_min,
	window_maximize = window_max,
	window_maximize_hover = window_max,
	window_close = window_close,
	window_close_hover = window_close,
}
config.font_size = 10
config.colors = {
	tab_bar = {
		background = "#333333",

		active_tab = {
			fg_color = "#ffffff",
			bg_color = "#444444",
		},

		new_tab = {
			bg_color = "#333333",
			fg_color = "#ffffff",
		},

		new_tab_hover = {
			bg_color = "#555555",
			fg_color = "#ffffff",
		},
	},
}
wezterm.on("format-tab-title", function(tab)
	local tab_index = string.format("  %s  ", tab.tab_index + 1)
	return wezterm.format({
		-- { Text = "▏" },
		{ Text = tab_index },
	})
end)

-- config.hide_tab_bar_if_only_one_tab = true
wezterm.on("update-right-status", function(window, pane)
	local user_vars = pane:get_user_vars()

	local date = " " .. wezterm.strftime("%r | %m-%d-%Y") .. " "

	-- figure out a way to center it
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#333333" } },
		{ Text = date },
	}))
end)

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end
config.keys = {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CTRL|ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
}
return config
