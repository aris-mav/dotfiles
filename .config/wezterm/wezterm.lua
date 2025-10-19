-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 20
config.color_scheme = 'GruvboxDark'
config.font = wezterm.font('JetBrains Mono')

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.default_prog = { 'fish', '-l' }

local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Finally, return the configuration to wezterm:
return config
