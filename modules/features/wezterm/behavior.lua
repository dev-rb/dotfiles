-- Loaded by the generated configuration after Nix settings.
-- `wezterm` and `config` are provided by the configuration writer.
local icons = wezterm.nerdfonts

local color_bg = wezterm.color.parse("#1D61D9")
local color_fg = wezterm.color.parse("#1DA0D8")

local function tab_title(tab_info)
	local title = tab_info.tab_title

	if title and #title > 0 then
		return string.match(title, "(%w+)/?$") or title
	end

	local pane = tab_info.active_pane
	local cwd = pane and pane.current_working_dir
	local path = cwd and cwd.file_path
	return (path and path:match("(%w+)/?$")) or (pane and pane.title) or ""
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
		{ Background = { Color = "black" } },
		{ Foreground = { Color = edge_fg } },
		{ Text = "" },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
		{ Background = { Color = "black" } },
		{ Foreground = { Color = edge_fg } },
		{ Text = " " },
	})
end)

wezterm.on("update-right-status", function(window, _pane)
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

	window:set_right_status(wezterm.format({
		{ Background = { Color = "black" } },
		{ Text = bat .. " " .. date },
	}))
end)

local function is_vim(pane)
	-- Set by smart-splits.nvim and unset on ExitPre in Neovim.
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
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

-- A host can replace the navigation bindings through Nix settings.keys.
config.keys = config.keys
	or {
		{
			key = "Q",
			mods = "CTRL|SHIFT",
			action = wezterm.action.QuitApplication,
		},
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
