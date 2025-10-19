local wezterm = require 'wezterm'
local action = wezterm.action
-- local mux = wezterm.mux

local module = {}

function module.apply_to_config(config)

    config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

    config.keys = {
        -- splits
        {
            key = "v",
            mods = "LEADER",
            action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
        },

        {
            key = "h",
            mods = "LEADER",
            action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },

        -- resizing
        {
            key = "h",
            mods = "ALT|SHIFT",
            action = action.AdjustPaneSize({ "Left", 2 }),
        },
        {
            key = "l",
            mods = "ALT|SHIFT",
            action = action.AdjustPaneSize({ "Right", 2 }),
        },
        {
            key = "j",
            mods = "ALT|SHIFT",
            action = action.AdjustPaneSize({ "Down", 2 }),
        },
        {
            key = "k",
            mods = "ALT|SHIFT",
            action = action.AdjustPaneSize({ "Up", 2 }),
        },
        -- zoom toggle
        {
            key = "z",
            mods = "LEADER",
            action = action.TogglePaneZoomState,
        },

        -- new window
        {
            key = "c",
            mods = "LEADER",
            action = action.SpawnTab("CurrentPaneDomain"),
        },

        -- movements
        {
            key = "p",
            mods = "LEADER",
            action = action.ActivateTabRelative(-1),
        },
        {
            key = "n",
            mods = "LEADER",
            action = action.ActivateTabRelative(1),
        },
        -- copy mode
        {
            key = "Space",
            mods = "LEADER",
            action = action.ActivateCopyMode
        },
    }

    -- switch tabs
    for i = 1, 9 do
        table.insert(config.keys, {
            key = tostring(i),
            mods = "LEADER",
            action = action.ActivateTab(i - 1),
        })
        table.insert(config.keys, {
            key = tostring(i),
            mods = "ALT",
            action = action.ActivateTab(i - 1),
        })
    end
end

return module
