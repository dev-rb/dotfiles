local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local icons = wezterm.nerdfonts

local function space(string, repLeft, repRight)
	repLeft = repLeft or 1
	repRight = repRight or 1
	return string.rep(" ", repLeft) .. string .. string.rep(" ", repRight)
end

-- This is where you actually apply your config choices
config.scrollback_lines = 3500
-- For example, changing the color scheme:
config.color_scheme = "Argonaut (Gogh)"
-- Fonts:
-- Monaspace Neon
-- JetBrainsMono Nerd Font Mono
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 10
config.line_height = 1.1
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

config.default_domain = "WSL:Ubuntu"
config.window_background_image = "D:/Desktop/Pictures/Wallpapers/wallhaven-vq3xd3.jpg"
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.1,

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
config.front_end = "WebGpu"
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
local window_min = space(icons.fae_minimize, 2, 2)
local window_max = space(icons.fae_maximize, 2, 2)
local window_close = space(icons.fae_thin_close, 2, 2)
config.tab_bar_style = {
	window_hide = window_min,
	window_hide_hover = window_min,
	window_maximize = window_max,
	window_maximize_hover = window_max,
	window_close = window_close,
	window_close_hover = wezterm.format({
		{ Background = { Color = "red" } },
		{ Text = window_close },
	}),
}
config.font_size = 10
local color_bg = wezterm.color.parse("#1D61D9")
local color_fg = wezterm.color.parse("#1DA0D8")
config.colors = {
	tab_bar = {
		background = "transparent",

		active_tab = {
			fg_color = color_fg:lighten(0.8),
			bg_color = color_bg:lighten(0.03),
		},

		new_tab = {
			bg_color = "#000",
			fg_color = "#ffffff",
		},

		new_tab_hover = {
			bg_color = "#151515",
			fg_color = "#ffffff",
		},
	},
}

config.window_frame = {
	active_titlebar_bg = "transparent",
	inactive_titlebar_bg = "transparent",
}
local function tab_title(tab_info)
	local title = tab_info.tab_title

	if title and #title > 0 then
		return string.match(title, "(%w+)/?$")
	end

	return tab_info.active_pane.current_working_dir:gsub("%.exe", ""):match("(%w+)/?$")
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local title = tab_title(tab)
	title = wezterm.truncate_right(title, max_width - 3)
	local bg = color_bg:darken(0.7)
	local fg = color_fg

	if tab.is_active then
		bg = bg:lighten(0.3)
		fg = fg:lighten(1)
	end
	if hover then
		bg = bg:lighten(0.1)
		fg = fg:lighten(0.1)
	end

	local edge_fg = bg

	return wezterm.format({
		{ Attribute = { Italic = false } },
		{ Attribute = { Intensity = "Normal" } },
		{ Background = { Color = "transparent" } },
		{ Foreground = { Color = edge_fg } },
		{ Text = "" },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
		{ Background = { Color = "transparent" } },
		{ Foreground = { Color = edge_fg } },
		{ Text = " " },
	})
end)

-- config.hide_tab_bar_if_only_one_tab = true
wezterm.on("update-right-status", function(window, pane)
	local user_vars = pane:get_user_vars()

	local date = " " .. wezterm.strftime("%r  %m/%d/%Y") .. " "
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local raw_charge = b.state_of_charge * 100
		local charge_str = string.format("%.0f", raw_charge)
		local trunc_charge = tonumber(charge_str)
		local multiple = math.floor(trunc_charge / 10) * 10
		local charging = b.state == "Charging"

		local icon_name = "md_battery"

		if trunc_charge ~= 100 then
			icon_name = icon_name .. (charging and "_charging" or "") .. "_" .. tostring(multiple)
		else
			if charging then
				icon_name = icon_name .. "_charging_100"
			end
		end

		local icon = icons[icon_name]

		bat = icon .. " " .. charge_str .. "%"
	end

	-- figure out a way to center it
	window:set_right_status(wezterm.format({
		{ Background = { Color = "transparent" } },
		{ Text = bat .. " " .. date },
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
