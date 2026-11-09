local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)

    config.font_size = 14
    config.font = wezterm.font('JetBrains Mono Nerd Font')

end

return M
