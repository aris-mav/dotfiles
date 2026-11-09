local wezterm = require 'wezterm'

local M = {}

function M.apply_to_config(config)

    config.inactive_pane_hsb = {
        saturation = 0.8,
        brightness = 0.8,
    }

    -- no top bar, but allow resizing from sides
    config.window_decorations = "RESIZE"

    -- config.initial_cols = 120
    -- config.initial_rows = 28

    config.color_scheme = 'GruvboxDark'

    config.use_fancy_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = false
    config.tab_bar_at_bottom = true

end

return M
