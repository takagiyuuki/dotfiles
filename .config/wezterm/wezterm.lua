local wezterm = require 'wezterm' --@type Wezterm
local config = wezterm.config_builder() --@type Config

-- Windows settings
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- default shell
  config.default_prog = {'wsl.exe', '-d', 'Ubuntu' }
  -- launcher menu
  config.launch_menu = {
    {
      label = 'WSL (Ubuntu)',
      args = { 'wsl.exe', '-d', 'Ubuntu' },
    },
    {
      label = 'PowerShell',
      args = { 'pwsh.exe' },
    },
    {
      label = 'Command Prompt',
      args = { 'cmd.exe' },
    },
  }
end

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

return config

