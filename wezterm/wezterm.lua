local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Appearance settings
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.93

-- Font configuration
local main_font = 'HackGen Console NF'
config.font = wezterm.font(main_font)
config.font_size = 12.0

config.window_frame = {
  font = wezterm.font(main_font),
  font_size = 10.0,
}

-- Default shell configuration (WSL Ubuntu)
-- Set default shell to WSL Ubuntu when running on Windows
if wezterm.target_triple:find("windows") then
    config.default_prog = { 'wsl.exe', '-d', 'Ubuntu' }
end

return config

