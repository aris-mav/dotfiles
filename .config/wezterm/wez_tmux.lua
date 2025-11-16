local wezterm = require 'wezterm'
local action = wezterm.action
-- local mux = wezterm.mux

local module = {}

local directions = {
    Left =  {"h", "LeftArrow"},
    Down =  {"j", "DownArrow"},
    Up =    {"k", "UpArrow"},
    Right = {"l", "RightArrow"},
}

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
            key = "[",
            mods = "ALT",
            action = action.ActivateCopyMode
        },
    }

    -- go to tab n
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

    -- resizing
    for dir, keys in pairs(directions) do
        for _, k in ipairs(keys) do
            table.insert(config.keys, {
                key = k,
                mods = "ALT|SHIFT",
                action = action.AdjustPaneSize({ dir, 2 }),
            })
        end
    end

    -- movements
    for dir, keys in pairs(directions) do
        for _, k in ipairs(keys) do
            table.insert(config.keys, {
                key = k,
                mods = "ALT",
                action = action.ActivatePaneDirection(dir)
                    or action.ActivateTab(dir),
                -- action = wezterm.action_callback(
                --     function(win, pane)
                --         local tab = pane:tab()
                --
                --         if tab:get_pane_direction(dir) ~= nil then
                --             win:perform_action(action.ActivatePaneDirection(dir), pane)
                --             return
                --         end
                --         action.ActivateTab(dir)
                --     end),
            })
        end
    end
end

return module
