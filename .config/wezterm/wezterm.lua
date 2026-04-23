local wezterm = require('wezterm') --@type wezterm
local config = wezterm.config_builder() --@type config

-- keybind settings
-- config.keys = require("keybinds").keys
-- config.key_tables = require("keybinds").key_tables
-- config.disable_default_key_bindings = true

-- Font configuration
local main_font = 'HackGen Console NF'

-- Windows settings
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- default current directory
  config.default_cwd = 'C:/'
  -- default shell
  config.default_prog = { 'wsl.exe', '-d', 'Ubuntu' }
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

-- Basic settings
config.enable_scroll_bar = true
config.exit_behavior = 'Hold'
config.automatically_reload_config = false

-- Font configuration
config.font = wezterm.font(main_font)
config.font_size = 12.0

-- Appearance settings
config.color_scheme = 'catppuccin-frappe'
config.window_background_opacity = 1.0
config.window_frame = {
  font = wezterm.font(main_font),
  font_size = 10.0,
}

-- Tabs
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true

return config
