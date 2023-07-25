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

-- For example, changing the color scheme:
config.color_scheme = "Argonaut (Gogh)"

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

config.keys = {
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

-- and finally, return the configuration to wezterm
return config
