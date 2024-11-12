local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 13.0
config.color_scheme = "Catppuccin Mocha"
config.set_environment_variables = {
	COLORTERM = "truecolor",
}

config.enable_tab_bar = false
config.window_background_opacity = 0.7
config.macos_window_background_blur = 20

config.enable_wayland = false

return config
