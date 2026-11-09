local wezterm = require 'wezterm'

-- List of your modules
local modules = {
    "appearance",
    "wez_tmux",
    "fullscreen",
    "autosplit",
    "font",
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

return config
