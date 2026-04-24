local wezterm = require('wezterm') --@type wezterm
local config = wezterm.config_builder() --@type config

-- keybind settings
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1500 }
config.keys = require('keybinds').keys
config.key_tables = require('keybinds').key_tables
-- config.disable_default_key_bindings = true -- disable default keybind

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
-- config.color_scheme = 'catppuccin-mocha'
config.color_scheme = 'Rosé Pine (base16)'
config.window_background_opacity = 1.0
config.window_frame = {
  font = wezterm.font(main_font),
  font_size = 10.0,
}
config.initial_cols = 50
config.initial_rows = 30

-- Panes
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.5,
}

-- Tabs
config.window_decorations = 'RESIZE'
config.tab_max_width = 20
config.hide_tab_bar_if_only_one_tab = true
-- colorful tabs
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local tab_colors = { -- catppuccin-mocha's color palette
    '#cba6f7', -- mauve
    '#89b4fa', -- blue
    '#a6e3a1', -- green
    '#f38ba8', -- red
    '#fab387', -- peach
    '#f9e2af', -- yellow
  }

  local cwd = tab.active_pane.current_working_dir -- display current directory in tab
  local dir = cwd and cwd.file_path:match('([^/]+)$') or '?'
  local label = string.format('%d: %s', tab.tab_index + 1, dir)

  -- trimming and padding for maz_width
  label = wezterm.truncate_right(label, max_width - 2)
  label = string.format(' %-' .. (max_width - 2) .. 's ', label) -- align left and padding right

  if not tab.is_active then
    return label -- be default style fot inactive tab
  end

  local bg = tab_colors[(tab.tab_index % #tab_colors) + 1]
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = '#1e1e2e' } },
    { Text = label },
  }
end)
return config
