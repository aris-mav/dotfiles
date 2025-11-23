local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)

    wezterm.on('window-resized',

        function(window, pane)

            local width = pane:get_dimensions().cols
            if width > 150 then
                pane:split { size = math.floor(width / 2 + 25) }
            elseif width > 120 then
                pane:split { size = 0.66 }
            end
        end

    )
end

-- return our module table
return module
