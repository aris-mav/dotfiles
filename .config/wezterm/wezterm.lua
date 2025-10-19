local wezterm = require 'wezterm'
local mux = wezterm.mux

-- List of your modules
local modules = {
    "appearance",
    "wez_tmux",
}

local config = {}

-- Apply each module to the config
for _, name in ipairs(modules) do
  local ok, mod = pcall(require, name)
  if ok and mod.apply_to_config then
    mod.apply_to_config(config)
  else
    wezterm.log_error('Failed to load module: ' .. name)
  end
end

-- set shell
config.default_prog = { 'fish', '-l' }

-- start with a split
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
  pane:split { size = 0.66 }
end)

return config
