return function(config)
	config.default_domain = "WSL:Ubuntu"
	config.default_cwd = "~"
	config.default_prog = { "wsl.exe" }
	config.unix_domains = {
		{
			name = "wsl-mux",
			serve_command = { "wsl", "wezterm-mux-server", "--daemonize" },
		},
	}

	config.background = {
		{
			source = {
				File = "D:/Desktop/Pictures/Wallpapers/wallhaven-exqwvk.jpg",
			},
			width = "Cover",
			height = "Cover",
			repeat_x = "NoRepeat",
			repeat_y = "NoRepeat",
			vertical_align = "Middle",
			horizontal_align = "Center",
			hsb = {

				-- Darken the background image by reducing it to 1/3rd
				brightness = 0.05,

				-- You can adjust the hue by scaling its value.
				-- a multiplier of 1.0 leaves the value unchanged.
				hue = 1.0,

				-- You can adjust the saturation also.
				saturation = 1.5,
			},
		},
	}
end
